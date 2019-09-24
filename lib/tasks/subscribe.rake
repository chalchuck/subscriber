task :stats => 'orta:statsetup'

namespace :orta do
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ["Services", "app/services"]
    CodeStatistics::TEST_TYPES << 'Service Tests'
  end
end
