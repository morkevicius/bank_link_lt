BankLinkLt::Swedbank.test_account_name = ' '

BankLinkLt::Swedbank.preferred_language = 'LIT' # LAT,EST,RUS,ENG
BankLinkLt::Swedbank.default_payment_service_id = 1002


BankLinkLt::Swedbank.account_number = ''
BankLinkLt::Swedbank.test_account_number= ''

BankLinkLt::Swedbank.account_sender_id = ''
BankLinkLt::Swedbank.test_account_sender_id = ''

BankLinkLt::Swedbank.account_payment_gateway_url = ''
BankLinkLt::Swedbank.test_account_payment_gateway_url = 'http://test-pay.com/bank-link/ibpay/swedbank'

BankLinkLt::Swedbank.account_bank_certificate = ''
BankLinkLt::Swedbank.test_account_bank_certificate = File.read("#{Rails.root}/certificates/")

BankLinkLt::Swedbank.account_private_key = ''
BankLinkLt::Swedbank.test_account_private_key =  File.read("#{Rails.root}/certificates/")

#-------------------------------------------------------------------

BankLinkLt::Seb.account_name = ''
BankLinkLt::Seb.test_account_name = ''

BankLinkLt::Seb.preferred_language = 'LIT' # LAT,EST,RUS,ENG
BankLinkLt::Swedbank.default_payment_service_id = 1001


BankLinkLt::Seb.account_number = ''
BankLinkLt::Seb.test_account_number = ''

BankLinkLt::Seb.account_sender_id = ''
BankLinkLt::Seb.test_account_sender_id = ''


BankLinkLt::Seb.account_payment_gateway_url = 'https://ebankas.seb.lt/cgi-bin/vbint.sh/vbnet.w'
BankLinkLt::Seb.test_account_payment_gateway_url = 'http://test-pay.com/bank-link/ibpay/seb'

BankLinkLt::Seb.account_bank_certificate = File.read("#{Rails.root}/certificates/")
BankLinkLt::Seb.test_account_bank_certificate = File.read("#{Rails.root}/certificates/")

BankLinkLt::Seb.account_private_key = ''
BankLinkLt::Seb.test_account_private_key =  File.read("#{Rails.root}/certificates/")

