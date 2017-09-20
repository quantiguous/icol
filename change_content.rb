app_files = Dir.glob("app/**/*")
spec_files = Dir.glob("spec/**/*")
files = []
files << app_files
files << spec_files
files.flatten!

replacements = {
 IcolApp: 'App',           
 IcolCustomer: 'Customer',           
 IcolNotification: 'Notification',           
 IcolNotifyStep: 'NotifyStep',           
 IcolNotifyTransaction: 'NotifyTransaction',           
 IcolValidateStep: 'ValidateStep',           
 icol_customers_path: 'customers_path',           
 audit_logs_icol_customer_path: 'audit_logs_customer_path',
 approve_icol_customer_path: 'approve_customer_path',
 new_icol_customer_path: 'new_customer_path',
 edit_icol_customer_path: 'edit_customer_path',
 icol_customer_path: 'customer_path', 
 icol_notifications_path: 'notifications_path',
 audit_steps_icol_notification_path: 'audit_steps_notification_path',
 icol_notification_path: 'notification_path',
 icol_notify_transactions_path: 'notify_transactions_path',
 new_icol_notify_transaction_path: 'new_notify_transaction_path',
 edit_icol_notify_transaction_path: 'edit_notify_transaction_path',
 icol_notify_transaction_path: 'notify_transaction_path',
 icol_validate_steps_path: 'validate_steps_path',
 icol_validate_step_path: 'validate_step_path',
 icol_customer_params: 'customer_params',
 icol_notify_transaction_params: 'notify_transaction_params',
 icol_customer: 'customer',
 icol_notification_id: 'notification_id',
 icol_notify_transaction: 'notify_transaction',
}

# main_app is to be used to refer to the main_apps helpers and router
main_app = {
 unapproved_records_path: 'main_app.unapproved_records_path',
}

# namespaces are used when referring to class constants (dropdowns)
namespaces = {
 Customer: 'Icol::Customer::',
}

# symbols are used in strong parameters and for associations
symbols = {
 icol_customer: ':customer',
 icol_notify_step: ':notify_step',
 icol_notify_steps: ':notify_steps',
 icol_notification: ':notification',
 icol_notify_transaction: ':notify_transaction',
 icol_notify_transactions: ':notify_transactions'
}

# models that have an approval need to be replaced
instance_variables = {
 icol_customer: '@customer',
}

def inplace_edit(file, bak, &block)
    old_stdout = $stdout
    argf = ARGF.clone

    argf.argv.replace [file]
    argf.inplace_mode = bak
    argf.each_line do |line|
        yield line
    end
    argf.close

    $stdout = old_stdout
end

files.each do |file| 
  if File.file?(file)
    inplace_edit file, '' do |line|
      line = line.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      line = line.gsub(/\w+/) { |m| replacements.fetch(m.to_sym, m) }
      #line = line.gsub(/(?<!main_app.)\w+/) { |m| main_app.fetch(m.to_sym, m) } 
      #line = line.gsub(/(?<!:)\w+::/) { |m| namespaces.fetch(m.chomp('::').to_sym, m) } 
      line = line.gsub(/:\w+/) { |m| symbols.fetch(m[1..-1].to_sym, m) } 
      #line = line.gsub(/@\w+/) { |m| instance_variables.fetch(m[1..-1].to_sym, m) } 
      print line
    end
  end
end
