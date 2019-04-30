COMPLETED = State.find_by_name('completed')
ACCEPTED = State.find_by_name('accepted')
REJECTED = State.find_by_name('rejected')
CANCELLED = State.find_by_name('cancelled')
ARCHIVED = State.find_by_name('archived').id
DRAFT = State.find_by_name('draft')
SENT = State.find_by_name('sent')

