_bank_link_lt_
============

### Payments via Lithuanian banks integration gem for Ruby on Rails

### Cert generation


BANKS = [swedbank, seb]

openssl req -new -out cert_request.pem -keyout private_key.pem

Generate private key and bank certificate
openssl req -new  -nodes -days 720 -x509 -newkey rsa:1024 -out target_bank_certificate.crt -keyout target_bank_private_key.pem -subj "/C=LT/L=your_city/O=your_host_company UAB/OU=BankLink/CN=www.your_host.lt/emailAddress=your_email/"

Generate a certificate signing request based on an existing certificate  (http://www.sslshopper.com/article-most-common-openssl-commands.html)
openssl x509 -x509toreq -in target_bank_certificate.crt -out target_bank_certificate_request.csr -signkey target_bank_private_key.key

check
openssl x509 -in target_bank_certificate.crt -text -noout

You will have provide your banks with generated target_bank_certificate_requests.


=============

#####for now in lithuanian

##SEB
###Requests

######"1001"
E. parduotuvė siunčia bankui duomenis apie mokėjimo nurodymą, kurių prisijungęs pirkėjas
negali modifikuoti. Sėkmingo mokėjimo atveju e. parduotuvei siunčiamas “1101”
pranešimas, nesėkmingo – “1901” pranešimas

######"1201"
E. parduotuvė siunčia bankui duomenis apie mokėjimo nurodymą, kurių prisijungęs pirkėjas
negali modifikuoti. Mokėtojui patvirtinus mokėjimo nurodymą jis yra perduodamas vykdyti,
o e. parduotuvei siunčiamas “1201” pranešimas, Reikšmė - mokėjimas priimtas*)

*Priimtas vykdyti mokėjimo nurodymas vėliau gali būti atmestas, pvz., dėl lėšų trūkumo sąskaitoje.

###Responses

######1201
Query "1101"
Bankas siunčia pranešimą parduotuvei apie sėkmingai atliktą mokėjimo nurodymą
Query "1901"
Bankas siunčia pranešimą parduotuvei apie nesėkmingai atliktą mokėjimo nurodymą


##SWED

###Requests
######„1002“
Prekybininkas siunčia bankui pasiraš
yto mokėjimo pavedimo duomenis, kurių klientas interneto banke
pakeisti negali. Jeigu mokėjimo pavedimas pateikiamas sėkmingai, prekybininkui parengiama už klausa
„1101“, o jeigu nesėkmingai – už klausos paketas „1901“. Gavėjo duomenys imami iš„Bank link“ sutarties.


###Responses
#####„1101“
Naudojama pateikiant atsakymą apie sėkmingai atliktą vietinį mokėjimo pavedimą.

Už klausa „1901“
Siunčiama, kai reikia pranešti apie nesėkmingą operaciją.