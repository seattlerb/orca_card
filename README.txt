= orca_card

* http://seattlerb.rubyforge.org/orca_card
* http://orcacard.com

== DESCRIPTION:

Dumps information about your ORCA card.  ORCA cards are Western Washington's
all-in-one transit smart card that allow travel via bus, train and ferry
throughout King, Kitsap, Snohomish and Pierce counties.

== FEATURES/PROBLEMS:

* Cheap hack
* No API

== SYNOPSIS:

  $ orca_card -u username -p passwsord
  Card 12345678 for adult
  E-purse active, balance $XX.75
  
  History:
  mm/dd/2009 HH:MM PM KC Metro Route RRR fare $1.75 (balance $XX.75)
  mm/dd/2009 HH:MM PM KC Metro Route RRR fare $1.75 (balance $XX.50)
  mm/dd/2009 HH:MM PM KC Metro Route RRR fare $2.00 (balance $XX.25)
  mm/dd/2009 HH:MM PM KC Metro Route RRR transfer
  mm/dd/2009 HH:MM PM KC Metro Route RRR fare $1.75 (balance $XX.25)
  mm/dd/2009 HH:MM PM Enabled Autoload, Receipt XXXXXXX
  mm/dd/2009 HH:MM PM Added purse value XX.00 to card
  mm/dd/2009 HH:MM PM Added purse value XX.00 to account, Receipt XXXXXXX

== REQUIREMENTS:

* An ORCA card tied to an account
* An internet connection

== INSTALL:

* gem install orca_card

== LICENSE:

(The MIT License)

Copyright (c) 2009 Eric Hodel

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
