# In future if the code finds the location too slowly, put the shelves in a 
# separate model.

class Element < ActiveRecord::Base
  belongs_to :element_type

  def self.find_shelf(library, identifier, shelfmark)
    shelfmark, optional = self.prepare_search_arguments(shelfmark)
    case library
    when 'main'
      self.classify_in_main(library, identifier, shelfmark, optional)
    when 'newcollege'
      self.classify_in_newcollege(library, identifier, shelfmark, optional)
    else
      # Put other libraries
    end
  end

  def self.prepare_search_arguments(shelfmark)
    # Saving prepend if any (The prepend can be either Folio or just F.(i.e. 4th floor))
    optional = self.find_optional(shelfmark)
    shelfmark.sub! optional, ''
    return shelfmark, optional
  end

  def self.find_optional(shelfmark)
    # Remove Ref. as it has no affect on the position but can confuse the algorithm
    # If there are other abbreviations of Ref. remove them also
    shelfmark.sub! 'Ref. ', ''
    # Find the optional if any(it would be always at the beginning)
    # If there is a new class or new abbreviation of Pamph and Folio put them here
    # https://docs.ruby-lang.org/en/trunk/Regexp.html (How to work with regexp and ruby)
    optional = shelfmark.match(/\A^((Folio )|(Pamph. )|(P. )|(F. )|(F )|(p)|(f)|(sf))/)
    optional.nil? ? '' : optional[0]
  end

  def start_range
    range_start_letters.to_s + range_start_digits.to_s
  end

  def end_range
    range_end_letters.to_s + range_end_digits.to_s
  end

  # MAIN LIBRARY
  #############################################################################
  # The books are ordered alphanumerically on shelves
  # On the 4th floor the classification system is a variant of dewey in the type .432423
  # Shelves can have tags 'Ref. Pamph.(or just P./P/p./p) Folio(or just F/f/F./f.)'
  # Books with 'Folio ' and 'Pamph. ' optional tags are only put on shelves(in the 
  # beginning of each sequence) with the same tag unless the shelfmark starts with 'N'
  # If the shelf range_start_letter start with N the Folio items are displayed just 
  # like the normal ones
  # If the book's shelfmark starts with 'N' it's optional tag can be ommited and 
  # the book is positioned as normally
  # The 'Folio ' and 'Pamph. ' books are
  # There are wrong shelves in the system, one should go around and check everything
  # When there is Ref. Folio don't write folio in the range start letters
  # TODO: Add tags to shelves and remove the optional thing
  def self.classify_in_main(library, identifier, shelfmark, optional)
    # Finding all shelves given condition
    answer = Element.select{ |el| el.element_type_id == 3 && el.identifier == identifier && 
      el.start_range<=shelfmark && el.end_range>=shelfmark}
    # If shelf starts with N the folios can be anywhere
    unless shelfmark[0]=='N' && ['Folio ', 'F. ', 'F '].include?(optional)
      answer.select{ |el| [el.range_start_opt, el.range_end_opt].include?(optional)}
    end
  end

  # NEWCOLLEGE LIBRARY
  #############################################################################
  # The books are ordered alphanumerically on shelves
  # On one of the floors the books are referenced as for example 'C4/b3 - C7/a5'
  # For that system to be used we substitute each number with letter code 
  # That way, we guarantee that 'B9'<'B10' as we would compare 'Bj' to 'Bk'
  # This works under the assumption that the numbers in the code do not exceed 25
  # If that changes, instead of changing the nums to letters, change them to numbers
  # with (5 - number.digit_count) zeros upfront so that it compares 00009 to 00010
  # Remove any lower-cased letters from the beginning(there are some sCB instead 
  # of just CB and same with 'r')
  def self.classify_in_newcollege(library, identifier, shelfmark, optional)
    shelfmark = shelfmark.start_with?('s', 'r') ? shelfmark[1..-1] : shelfmark

    # The strange classification in the form A9/b2
    if shelfmark.include?('/')
      shelfmark = shelfmark.to_alphanum
      Element.select{ |el| el.element_type_id == 3 && el.identifier == identifier && el.start_range.include?('/') &&
        el.start_range.to_alphanum<=shelfmark && el.end_range.to_alphanum>=shelfmark && ["", el.range_start_opt, el.range_end_opt].include?(optional)}
    # Normal letter classification
    else
      Element.select{ |el| el.element_type_id == 3 && el.identifier == identifier &&
        el.start_range<=shelfmark && el.end_range>=shelfmark && ["", el.range_start_opt, el.range_end_opt].include?(optional)}
    end
  end
end
