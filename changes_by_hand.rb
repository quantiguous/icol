customers/_form.html.haml
    = link_to :Cancel, customers_path, :name => 'cancel', :class=>"cancel btn"

customers/show.html.haml
        %a.btn{:href => "#{!(can) ? '#' : edit_customer_path(@customer)}", :role => "button", :class => "btn btn-primary #{(can) ? '' : 'disabled'}"} Edit
 = link_to "#{audit_count(@customer)}", audit_logs_customer_path(@customer, :version_id => audit_count(@customer))

notify_transactions/_form.html.haml
    = link_to :Cancel, notify_transactions_path, :name => 'cancel', :class=>"cancel btn"

customers_contrller.rb
      @customer.attributes = customer_params

notify_transactions_controller.rb
      @icol_notify_transaction.attributes = notify_transaction_params

notify_step.rb
    belongs_to :notification, foreign_key: :icol_notification_id
