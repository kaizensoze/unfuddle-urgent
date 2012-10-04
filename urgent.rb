#!/usr/bin/ruby

require 'curb'
require 'date'
require 'json'

def check_tickets()
  auth = File.open('auth.txt', &:readline)
  user, pass = auth.split(/:/)

  url = "https://elephantventures.unfuddle.com/api/v1/projects/1042/tickets?format=json"

  c = Curl::Easy.new(url)
  c.http_auth_types = :basic
  c.username = user
  c.password = pass
  c.perform

  ticket_data = c.body_str
  # puts JSON.pretty_generate(ticket)
  tickets = JSON.parse(ticket_data)

  tickets.each do |ticket|
    ticket_created_at = ticket['created_at']
    ticket_datetime = DateTime.parse(ticket_created_at)

    time_ago = DateTime.now - ticket_datetime
    time_ago_in_minutes = (time_ago * 24 * 60).to_i
    
    if time_ago_in_minutes < 5000  # or whatever you set the crontab at
      if ticket['priority'].to_i >= 4
        `afplay foreigner_urgent_part.mp3`
        break
      end
    end
  end
end

if __FILE__ == $0
  check_tickets()
end
