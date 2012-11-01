Gem::Specification.new do |s|
  s.name        = 'rails-canhaz'
  s.version     = '1.0.3'
  s.date        = '2012-11-01'
  s.summary     = "A simple gem for managing permissions between rails models"
  s.description = "A simple gem for managing permissions between rails models"
  s.authors     = ["Adrien Siami (Intrepidd)"]
  s.email       = 'adrien@siami.fr'
  s.files       = `git ls-files`.split("\n")

  s.homepage    = 'http://github.com/Intrepidd/rails-canhaz'

  s.add_dependency 'activerecord', '>= 3.1.0'

end
