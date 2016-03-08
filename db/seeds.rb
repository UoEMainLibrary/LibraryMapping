# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ElementType.create([
                       {id: 1, name: "Chair", svg_path: "chair"},
                       {id: 2, name: "Coffee Table", svg_path: "coffeetable"},
                       {id: 3, name: "Computer Table", svg_path: "computertable"},
                       {id: 4, name: "Entrance Barrier", svg_path: "entrancebarrier"},
                       {id: 5, name: "Group Study Pod", svg_path: "groupstudy"},
                       {id: 6, name: "User Terminal", svg_path: "userterminal"},
                       {id: 7, name: "Information Service (Large)", svg_path: "informationservice-large"},
                       {id: 8, name: "Information Service (Small)", svg_path: "informationservice-small"},
                       {id: 9, name: "Meeting Table", svg_path: "meetingtable"},
                       {id: 10, name: "Round Table", svg_path: "roundtable"},
                       {id: 11, name: "Shelf", svg_path: "shelf"},
                       {id: 12, name: "Student Information", svg_path: "studentinformation"},
                       {id: 13, name: "Study table", svg_path: "studytable"},
                       {id: 14, name: "User Terminal", svg_path: "userterminal"},

                       # icons
                       {id: 15, name: "Accessible toiled", svg_path: "A-toilet"},
                       {id: 16, name: "Cafe", svg_path: "cafe"},
                       {id: 17, name: "Computer Clinic", svg_path: "computerclinic"},
                       {id: 18, name: "Exit", svg_path: "exit"},
                       {id: 19, name: "Female toilet", svg_path: "F-toilet"},
                       {id: 20, name: "Help Desk", svg_path: "helpdesk"},
                       {id: 21, name: "Fire lift", svg_path: "firelift"},
                       {id: 22, name: "Lift", svg_path: "lift"},
                       {id: 23, name: "Male toilet", svg_path: "M-toilet"},
                       {id: 24, name: "Meeting Suite", svg_path: "meetingsuite"},
                       {id: 25, name: "Music Listening Service", svg_path: "musiclisteningservice"},
                       {id: 26, name: "Platform Lift", svg_path: "platformlift"},
                       {id: 27, name: "Return terminal", svg_path: "return"},
                       {id: 28, name: "Stairs", svg_path: "stairs"}
                   ]);