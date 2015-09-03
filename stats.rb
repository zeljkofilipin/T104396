# http://ruby-doc.org/stdlib-2.2.3/libdoc/open-uri/rdoc/OpenURI.html
require 'open-uri'
url = 'https://integration.wikimedia.org/ci/job/browsertests-CentralAuth-en.wikipedia.beta.wmflabs.org-linux-firefox-sauce/api/json?tree=builds[duration]'
open(url) do |f|

  # http://ruby-doc.org/stdlib-2.2.3/libdoc/json/rdoc/JSON.html
  require 'json'
  builds = JSON.parse(f.read)

  durations = builds['builds'].collect do |duration|
    duration['duration']
  end

  p durations

  # https://rubygems.org/gems/descriptive_statistics
  require 'descriptive_statistics'

  data = durations
  p durations.median

end
