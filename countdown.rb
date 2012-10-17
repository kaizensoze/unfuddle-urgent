require 'curb'
require 'date'
require 'json'

def check_tickets()
  auth = File.open('auth.txt', &:readline)
  user, pass = auth.split(/:/)

  url = "https://elephantventures.unfuddle.com/api/v1/projects/1042/ticket_reports/1449/generate?format=json"

  c = Curl::Easy.new(url)
  c.http_auth_types = :basic
  c.username = user
  c.password = pass
  c.perform

  report = JSON.parse(c.body_str)
  # puts JSON.pretty_generate(report)
  tickets_remaining = report['groups'][0]['tickets'].length
  `say 'Tickets remaining: #{tickets_remaining}.'`
end

if __FILE__ == $0
  check_tickets()
end
