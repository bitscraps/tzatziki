class CreateFailures < ActiveRecord::Migration[6.1]
  def change
    create_table :failures do |t|
      t.string :test_file
      t.string :test_name
      t.integer :line_number
      t.text :failure

      t.timestamps
    end
  end
end
