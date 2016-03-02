# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ElementType.create([{id: 1, name: "Trash can", svg_path: "basura"}, {id: 2, name: "Study table", svg_path: "studytable"}, {id: 3, name: "Computer Table", svg_path: "computerTable"}, {id: 4, name: "Shelf", svg_path: "shelf"}, {id: 5, name: "Coffee Table", svg_path: "coffeetable"} ]);