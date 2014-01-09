FriendlyId.defaults do |config|
  config.base = :name
  config.use :slugged
  config.sequence_separator = "--" #change this to change the separator for the index
end