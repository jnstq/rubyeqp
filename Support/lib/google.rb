#!/usr/bin/env ruby -w
require 'net/http'
require 'uri/common'
require 'cgi'
Net::HTTP.version_1_2
module Google
  def Google.search(inputterms, numresults=1)
    unless inputterms.length > 0
      return "What should I search for?"
    end
    searchterms = URI.escape inputterms

    query = "/search?q=#{searchterms}&btnG=Google+Search"
    result = "no results found."

    proxy_host = nil
    proxy_port = nil

    if(ENV['http_proxy'])
      if(ENV['http_proxy'] =~ /^http:\/\/(.+):(\d+)$/)
        proxy_host = $1
        proxy_port = $2
      end
    end
    http = Net::HTTP.new("www.google.com", 80, proxy_host, proxy_port)

    http.start do |http|
      begin
        resp = http.get(query)
        if resp.code.to_i == 200
          didyoumean = nil
          results = []
          resp.body.each("Similar pages</a>") do |l|
            if not didyoumean and l =~ /Did you mean:.*?<i>(.*?)<\/i>.*?<\/a>/
              didyoumean = $1
            end
            if (l =~ /(<p class="?g"?>)(<a.*?<\/a>)/) and (results.size < numresults)
              results.push("Hit #{results.size + 1}: #{$2}")
            end
          end
          unless results.empty?
            result = results.join("\n")
            if (results.size < numresults) and didyoumean
              result += " (Did you mean <i>#{didyoumean}</i>?)."
            else
              result += "."
            end
            # comment out the line below to leave the search terms bolded
            result.gsub!(/<b>|<\/b>/, "")
          else
            if didyoumean
              result += "\n(Did you mean <i>#{didyoumean}</i>?)."
            end
          end
        end
      rescue => e
        result = "Error encountered while talking to Google."
      end
    end
    CGI.unescapeHTML result
  end
end