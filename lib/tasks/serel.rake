require 'topstack/serel'

namespace :serel do
  desc "Get the top 10 questions using serel"
  task :test_questions => :environment do
    puts ::TopStack::Serel.instance.questions({top: 10})
  end

  desc "Get top answer to top question using serel"
  task :test_answer => :environment do
    q = ::TopStack::Serel.instance.questions({top: 1}).first
    puts ::TopStack::Serel.instance.answer(q['accepted_answer_id'])
  end

  desc "List tags using serel"
  task :test_tags => :environment do
    puts ::TopStack::Serel.instance.tags
  end
end
