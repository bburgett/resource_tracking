require File.join(File.dirname(__FILE__),'./blueprint.rb')

Factory.define :data_response, :class => DataResponse do |f|
  f.responding_organization  { Factory.create(:organization) }
  f.currency                 { 'USD' }
end