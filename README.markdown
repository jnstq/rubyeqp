RubyEQP
=======

This is my personal TextMate bundle where i put useful command and snippets.

Commands
--------

* Diff agaist saved 
  * Check if something changed in the current document
* Beautify ruby code
  * Fast way to get all indentation correct. I found this on a blog by P. Lutus and modified for TextMate by T. Burks
* Google did you mean?
  * I use this for spell checking method names, really nice and accurate
* Factory Girl Skeleton
  * In a rails application set on cursor on a model name, for example photo, and hit Ctrl+Cmd+T and search for Factory Skeletion, this will generate code for a factory with all default column values. Time saver!


Will generate

    Factory.define :photo do |p|
      p.bucket_name "Value for bucket_name"
      p.content_type "Value for content_type"
      p.pictured_at { Time.now }
      p.thumbnail "Value for thumbnail"
      p.size 1
      p.filename "Value for filename"
      p.height 1
      p.state "Value for state"
      p.width 1
    end

