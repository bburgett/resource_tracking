# A basic setup for a CI server
#
# this script assumes its run from the RAILS_ROOT dir
#
# to configure your CI Joe server, add this
#   $ git config --add cijoe.runner "ruby lib/tasks/ci.rb"
#
EXIT_OK   = 0
EXIT_NOK  = 1

# copy in any yamls not in the repo
system "cp config/database.yml.sample config/database.yml"
system "cp config/settings.secret.example.yml config/settings.secret.yml"

# run db creation and seeding
setup_and_seeded = system "export RAILS_ENV=cucumber && rake setup --trace"
unless setup_and_seeded
  puts "environment setup failed"
  exit EXIT_NOK
end

# cijoe build
built = system "export RAILS_ENV=cucumber && rake -s test"
exit EXIT_NOK unless built

exit EXIT_OK