# BasicQuest!

## Usage
From the command line, run the `bin/bq` commands:

    $ ./bq

To run the tests, just run:

    $ rake


## Compatibility and dependencies

I developed this with ruby 1.9.3-p194 and tested that it works with ruby 1.8.7, 1.9.2 & jruby-1.7 (sorry no jruby-1.6 since that is based on ruby 1.8.7 and I am using the backports gem for 1.8.7 compatibility). There are no gem dependencies, except if you are running ruby 1.8.7, in which case you will need the backports gem. You will need the rake gem to run the tests, but should be able to run those without rake as well (the Rakefile is pretty simple).

## Note on tests

I used the TMF testing tool for this. It's a new ruby testing tool I created which is about 30 lines of code and very minimalistic. Hopefully, it's usage is pretty straightforward, but more info can be found at: https://github.com/bowsersenior/tmf


# Thanks!
Hope you have as much fun reading this code as I did writing it!

Best,
Mani