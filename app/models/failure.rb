
require 'csv'
class Failure < ApplicationRecord

  def total_count
    Failure.where(repo_name: repo_name, build_number: build_number, branch: branch).count
  end

  def other_instances
    Failure.where.not(branch: branch).where(test_file: test_file, test_name: test_name, created_at: 30.days.ago...).count
  end

  def self.to_csv
    attributes = %w{repo_name build_number branch username circle_job test_name test_file line_number failure}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
