#Arcana
Arcana lets you build spells into your Ruby apps. That is to say, it lets you define words using lambdas, such that strings of those words, if ordered correctly, cause those lambdas to execute.

Arcana has two components - **Tomes**, which you extend to define spell words, and a **Demon** (_not_ a daemon), which can parse a spell and execute the logic defined in the Tome.

Still confused? Let's try an example. Suppose you define a new Tome called `TreeLore`, that looks like this:

```ruby
class TreeLore
  extend Arcana::Tome
  type :arboria, -> { Tree.all }
  selector :minimis, -> (t) { t.where(size: :small) }
  action :gorgal, -> (rs, o) { o.update_all(size: rs[:size]) if rs[:size] }
  refinement :grandis, -> (rs) { rs.merge(size: :large) }
end
```

With this code you have handily defined one of each category of spell words - a _type_, a _selector_, an _action_ and a _refinement_.

With these in place, you can now cast a spell:
```ruby
 demon = Arcana::Demon.new
 demon.assimilate TreeLore
 demon.cast 'arboria minimis gorgal grandis'
```

The Demon will parse the string passed in `cast` according to the definitions provided in TreeLore. The code that executes will be broadly:

```ruby
 refinements = { size: :large }
 Tree.all
     .where(size: :small)
     .update_all(size: refinements[:size] if refinements[:size])
```

And just like that, you've cast your first spell. Adding more spell words to your Tome will increase the number and permutations of valid spells you can cast.

##Word Types
There are four types of spell word you can define, each via a lambda as in the above example.

###Types
These define the type of thing the spell should operate on. The lambda for these should return any object and accept no arguments

###Selectors
Selectors are methods that can be chained to a type to alter it. They should accept one argument - the type to refine - and return an object of the same class (or a class with a matching API).

###Actions
These are the things that affect an object. They do not need to return a value, but they should accept two or more arguments - a hash of refinements (see below), and the object(s) to affect.

###Refinements
Refinements are used to build an option hash to pass to an action to modify it. They should accept and return a hash.

##Parsing spells
The Demon reads spells by breaking them into semantic blocks. There are two types of semantic block, an Object and a Verb (named after the building blocks of sentences - the Subject is the Demon itself). A valid spell comprises one or more Objects followed by a Verb.

Each semantic block comprises one or more words. An Object is made up of a Type followed by  zero or more Selectors. A Verb is made up of an Action followed by zero or more Refinements. So the following is a valid structure for a spell:

```
 TYPE SELECTOR   TYPE     ACTION REFINEMENT REFINEMENT
^--OBJECT-----^ ^OBJECT^ ^--VERB----------------------^
```

Note that the Demon can't guarantee that just because a spell is structurally valid it will be possible to execute it. For example, the Action in the above example must work when given two Objects.
