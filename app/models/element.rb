# In future if the code finds the location too slowly, put the shelves in a 
# separate model.
class Element < ActiveRecord::Base
  belongs_to :element_type

  def self.find_shelf(library, identifier, shelfmark)
    shelfmark, optional, part_one, part_two = self.prepare_search_arguments(shelfmark)
    elements = self.feasible_elements(library, identifier)
    elements = self.common_filter(elements, part_one, part_two, identifier, optional)
    case library
    when 'main'
      return self.classify_in_main(elements, optional, part_one, part_two)
    when 'newcollege'
      return self.classify_in_newcollege(elements, optional, part_one, part_tow)
    when 'murray'
      return self.classify_in_murray(elements, optional, part_one, part_two) 
    else ## add other libraries
    end
  end

  # If there is a new class or new abbreviation of Pamph and Folio put them here
  def self.tags
    ['p ', 'p. ', 'P ', 'P. ', 'Pamph. ', 'F ', 'F. ', 'Folio ', 'f ', 'f. ', 'sf ', 'Per. ']
  end
# No matter the system used, there are always two parts of any book code
# AB12 AB-part one 12-part 2
# C4/b3 C4-part one b3-part 2
# .092(8327) Gar .092-part one 8Gar-part 2
# Transform part_one and part_two to the way you would like them to be compared
# For example if you want '345' to be compared as a number, send '345'.to_i
  def self.prepare_search_arguments(shelfmark)
    # Saving prepend if any (The prepend can be either Folio or just F.(i.e. 4th floor))
    optional = self.find_optional(shelfmark)
    # Removing prepend
    shelfmark.sub! optional, '' unless optional == ' '
    # Removing confusing 's' and 'r' in Newcollege
    shelfmark = shelfmark.start_with?('s', 'r') ? shelfmark[1..-1] : shelfmark
    # Dewey example .01 exa - 0.1 exc
    if shelfmark[0] == '.' # if there are any other shelmarks with a . change this condition
      if shelfmark.include?('(')
        shelfmark.sub! ')', ''
        part_one, part_two = shelfmark.split('(')
      else
        part_one = shelfmark.to_f.to_s[1..-1]
        part_two = shelfmark.split(' ').second
      end
    # C.A.S. on fourth floor
    elsif shelfmark.include?('C.A.S.')
      part_one, part_two = shelfmark.split(' ').drop(1)
    # Strange system in Newcollege example A8/b3
    elsif shelfmark.include?('/') 
      part_one, part_two = shelfmark.split('/')
      part_one = part_one.to_alphanum
    # Normal system example AB12-AC19
    else 
      part_one = shelfmark.split(/\d/).try(:first)
      part_two = shelfmark[part_one.length..-1].to_i unless part_one.blank?
    end

    return shelfmark, optional, part_one, part_two
  end

  def self.find_optional(shelfmark)
    # Remove Ref. as it has no affect on the position but can confuse the algorithm
    # If there are other abbreviations of Ref. remove them also
    shelfmark.sub! 'Ref. ', ''

    # Find the optional if any(it would be always at the beginning)
    # https://docs.ruby-lang.org/en/trunk/Regexp.html (How to work with regexp and ruby)
    optional = shelfmark.match(/\A^(#{'(' + Element.tags.join(')|(') + ')'})/)
    optional.nil? ? ' ' : optional[0]
  end

  def self.feasible_elements(library, identifier)
    Element.where(element_type_id: 3, library: library, identifier: identifier)
  end

  def self.common_filter(elements, part_one, part_two, identifier, optional)
    if part_two.class == Fixnum
      if optional == ' '
        elements.select{ |el| (el.range_start_letters || '') <= part_one &&
                              (el.range_end_letters   || '') >= part_one &&
                              (el.range_start_digits.to_i <= part_two || el.range_start_letters < part_one) &&
                              (el.range_end_digits.to_i   >= part_two || el.range_end_letters   > part_one) &&
                              (el.range_start_opt.blank? || el.range_end_opt.blank?) }
      else
        elements.select{ |el| (el.range_start_letters || '') <= part_one &&
                              (el.range_end_letters   || '') >= part_one &&
                              (el.range_start_digits.to_i <= part_two || el.range_start_letters < part_one) &&
                              (el.range_end_digits.to_i   >= part_two || el.range_end_letters   > part_one) &&
                              (!el.range_start_opt.blank? || !el.range_end_opt.blank?) }
      end
    elsif identifier == 'dewey_main'
      if optional == ' '
        elements.select{ |el| (el.range_start_digits.to_s <= part_one) &&
                              (el.range_end_digits.to_s   >= part_one) &&
                              (el.range_start_opt.blank? || el.range_end_opt.blank?) }
      else
        elements.select{ |el| (el.range_start_digits.to_s <= part_one) &&
                              (el.range_end_digits.to_s   >= part_one) &&
                              (el.range_start_opt == optional || el.range_end_opt == optional) }
      end
    elsif identifier == 'collection_newcollege'
      elements.select{ |el| (el.range_start_letters.to_alphanum || '') <= part_one &&
                           (el.range_end_letters.to_alphanum   || '') >= part_one &&
                           (el.range_start_digits.to_alphanum <= part_two || el.range_start_letters.to_alphanum < part_one) &&
                           (el.range_end_digits.to_alphanum   >= part_two || el.range_end_letters.to_alphanum   > part_one) }
    else
      elements.select{ |el| (el.range_start_letters || '') <= part_one.to_s &&
                           (el.range_end_letters   || '') >= part_one.to_s &&
                           (el.range_start_digits.to_s <= part_two || el.range_start_letters < part_one) &&
                           (el.range_end_digits.to_s   >= part_two || el.range_end_letters   > part_one) }
    end
  end

  def self.require_optional(elements, optional)
    elements.select{ |el| el.range_start_opt.include?('|' + optional)}
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
  def self.classify_in_main(elements, optional, part_one, part_two)
    # If shelf starts with N the folios can be anywhere
    # part_one.to_s.first=='N' && ['Folio ', 'F. ', 'F '].include?(optional) ? Element.require_optional(elements, optional) : elements
    # taking care of optional in common_filter so just return elements
    elements
  end

  # NEWCOLLEGE LIBRARY
  #############################################################################
  # The books are ordered alphanumerically on shelves
  # On one of the floors the books are referenced as for example 'C4/b3 - C7/a5'
  # For that system to be used we substitute each number with letter code 
  # That way, we guarantee that 'B9'<'B10' as we would compare 'Bj' to 'Bk'
  # This works under the assumption that the numbers in the code do not exceed 25
  # If that's not the case, instead of changing the nums to letters, change them to numbers
  # with (5 - number.digit_count) zeros upfront so that it compares 'B00009' to 'B00010'
  # Remove any lower-cased letters from the beginning(there are some sCB instead 
  # of just CB and same with 'r')
  def self.classify_in_newcollege(elements, optional, part_one, part_two)
    elements
  end

  # MURRAY LIBRARY
  #############################################################################
  # The books are ordered alphanumerically on shelves
  # The only difference with the normal classification is that there are
  # two special shelves for frquently used books and all reserved books
  # stay there. 
  def self.classify_in_murray(elements, optional, part_one, part_two)
    elements
  end

end

