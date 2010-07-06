class AddQuarterlyFunding < ActiveRecord::Migration
  def self.up
    add_column :activities, :budget_q1, :decimal
    add_column :activities, :budget_q2, :decimal
    add_column :activities, :budget_q3, :decimal
    add_column :activities, :budget_q4, :decimal
    add_column :activities, :spend_q1, :decimal
    add_column :activities, :spend_q2, :decimal
    add_column :activities, :spend_q3, :decimal
    add_column :activities, :spend_q4, :decimal
    add_column :projects, :budget_q1, :decimal
    add_column :projects, :budget_q2, :decimal
    add_column :projects, :budget_q3, :decimal
    add_column :projects, :budget_q4, :decimal
    add_column :projects, :spend_q1, :decimal
    add_column :projects, :spend_q2, :decimal
    add_column :projects, :spend_q3, :decimal
    add_column :projects, :spend_q4, :decimal
    add_column :funding_flows, :budget_q1, :decimal
    add_column :funding_flows, :budget_q2, :decimal
    add_column :funding_flows, :budget_q3, :decimal
    add_column :funding_flows, :budget_q4, :decimal
    add_column :funding_flows, :spend_q1, :decimal
    add_column :funding_flows, :spend_q2, :decimal
    add_column :funding_flows, :spend_q3, :decimal
    add_column :funding_flows, :spend_q4, :decimal
  end

  def self.down
    remove_column :funding_flows, :spend_q4
    remove_column :funding_flows, :spend_q3
    remove_column :funding_flows, :spend_q2
    remove_column :funding_flows, :spend_q1
    remove_column :funding_flows, :budget_q4
    remove_column :funding_flows, :budget_q3
    remove_column :funding_flows, :budget_q2
    remove_column :funding_flows, :budget_q1
    remove_column :projects, :spend_q4
    remove_column :projects, :spend_q3
    remove_column :projects, :spend_q2
    remove_column :projects, :spend_q1
    remove_column :projects, :budget_q4
    remove_column :projects, :budget_q3
    remove_column :projects, :budget_q2
    remove_column :projects, :budget_q1
    remove_column :activities, :spend_q4
    remove_column :activities, :spend_q3
    remove_column :activities, :spend_q2
    remove_column :activities, :spend_q1
    remove_column :activities, :budget_q4
    remove_column :activities, :budget_q3
    remove_column :activities, :budget_q2
    remove_column :activities, :budget_q1
  end
end
