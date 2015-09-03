# http://ruby-doc.org/stdlib-2.2.3/libdoc/json/rdoc/JSON.html
require 'json'

# http://ruby-doc.org/stdlib-2.2.3/libdoc/open-uri/rdoc/OpenURI.html
require 'open-uri'

def job_names(jenkins_url)
  jobs_url = "#{jenkins_url}api/json?tree=jobs[name]"
  open(jobs_url) do |f|
    jobs = JSON.parse(f.read)
    names = jobs['jobs'].collect do |name|
      name['name']
    end
    return names
  end
end

def job_duration_median(jenkins_url, job_name)
  job_url = "#{jenkins_url}job/#{job_name}/api/json?tree=builds[duration]"
  open(job_url) do |f|
    builds = JSON.parse(f.read)
    durations = builds['builds'].collect do |duration|
      duration['duration']
    end

  # https://rubygems.org/gems/descriptive_statistics
  require 'descriptive_statistics'
  return durations.median/60000 # convert ms to min
  end
end

def job_name_and_job_duration_median(jenkins_url, jobs)
  jobs.collect do |job_name|
    # http://ruby-doc.org/core-2.2.3/Regexp.html
    [job_name, job_duration_median(jenkins_url, job_name)] if job_name.match(/^browsertests-.*/)
  end.compact
end

jenkins_url = 'https://integration.wikimedia.org/ci/'
jobs = job_names(jenkins_url)
job_name_and_job_duration_median(jenkins_url, jobs).each do |job_name, median|
  # puts "%20s %s" % [median, job_name]
  puts "%10s %s" % [median.round(1), job_name]
end
