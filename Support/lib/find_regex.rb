module FindRegex
  def self.parse(line)
    return $1 if line =~ /\/(.*)\//
    return $2 if line =~ /%r(.){1}(.+)(\1|[)\]}]){1}/
    line
  end
end