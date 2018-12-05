# Using a Model


## Overview

[ needs to be cleaned up ]

There's a ton of structured data that I want to be preserved and retuned to the caller when the
function is run. Previously, I would define the data at the top of each function. This became difficult to maintain, especially during the development phase when names and logic were changing
a lot.

I ended up decided to create a 'model' which might have been better named a structure or schema. Its purpose is simply to give me a specific locaiton that defines all the data that I'm
going to be working with throughout the model. This servics a few functions:


A function doing some work can reference this model, update this model.
It gives the advantages of database while existing only in memory.
A quick place to reference objects and properties
less code duplication


The unfortunate thing is that, while you can import class defined in modules in powershell, ( see using module keyword ), if your classes are nested and inherit from other custom classes you run
into tons of import issues as there's not an easy way to define the class import order. For
reason I couldn't expand on this idea as much as I wanted to.