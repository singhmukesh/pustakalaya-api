json.extract! lease
json.issue_date lease.issue_date.to_i
json.due_date lease.due_date.to_i
json.return_date lease.return_date.to_i if lease.return_date.present?
json.renew_count lease.renew_count if lease.item.type == Book.to_s
