
require 'csv'
class Failure < ApplicationRecord

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
