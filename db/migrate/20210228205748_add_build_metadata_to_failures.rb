class AddBuildMetadataToFailures < ActiveRecord::Migration[6.1]
  def change
    add_column :failures, :repo_name, :string
    add_column :failures, :build_number, :string
    add_column :failures, :branch, :string
    add_column :failures, :username, :string
    add_column :failures, :circle_job, :string
  end
end
