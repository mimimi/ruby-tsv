# Tsv
[![Build Status](https://travis-ci.org/mimimi/ruby-tsv.svg?branch=master)](https://travis-ci.org/mimimi/ruby-tsv)

A simple TSV parser, developed with aim of parsing a ~200Gb TSV dump. As such, no mode of operation, but enumerable is considered sane. Feel free to use `#to_a` on your supercomputer :)

Does not (yet) provide TSV writing mechanism. Pull requests are welcome :)

## Installation

Add this line to your application's Gemfile:

    gem 'tsv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tsv

## Usage

### High level interfaces

#### TSV::parse

`TSV.parse` accepts TSV as a whole string, returning lazy enumerator, yielding TSV::Row objects on demand

#### TSV::parse_file

`TSV.parse_file` accepts path to TSV file, returning lazy enumerator, yielding TSV::Row objects on demand
`TSV.parse_file` is also aliased as `[]`, allowing for `TSV[filename]` syntax

#### TSV::Row

By default TSV::Row behaves like an Array of strings, derived from TSV row. Every row contains header data, accessible via `#header` reader.

In case a hash-like behaviour is required, field can be accessed with string key. Alternatively, `#with_header` and `#to_h` return hash representation for the row.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
