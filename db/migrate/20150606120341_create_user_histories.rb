class CreateUserHistories < ActiveRecord::Migration
  def change
    create_table :user_histories do |t|
      t.string :terms
      #foreign key references
      t.references :user, index: false, :null => false
    end
  end
end
