# metrics

Fine-tuned metric_fu configuration.

## Description

Running [metric_fu](https://github.com/metric_fu/metric_fu) can be a little slow if you run on our whole product. 

So, I found how to run the same suite only on specific subdirectory and only on the files we're interested on.

Also, I disabled some metrics I usually run separately (like Simplecov) or which I'm not interested in.

## Installing in your project

Within your project directory, execute the following steps.

1. Install the Ruby gem:
  
    ```bash
    gem install metric_fu
    ```

    **Note:** At least metric_fu 4.4.1 is required.

1. Clone the repo:

    ```bash
    git clone https://github.com/ShogunPanda/metrics.git
    ```

1. Load the metric_fu configuration:

    ```bash
    ln -s metrics/metric_fu.rb .metrics
    ```

    *Obviously this is not needed for manual execution.*

1. Added some entries to .gitignore *(optional, but recommended)*:

    ```bash
    echo "metrics/" >> .gitignore
    echo ".metrics" >> .gitignore
    echo "tmp/metric_fu" >> .gitignore
    ```

To execute the last three steps, you can also use the installer:

`curl -s -L https://raw.github.com/ShogunPanda/metrics/master/installer | sh`

## Running metrics automatically

`SOURCES` is a list of directory of Ruby SOURCES. **Point this to the actual implementation, not to the spec folder**.

```bash
MF_SOURCES=$SOURCES metric_fu
```

## Running metrics manually

From now on, `SOURCES` is a single directory of Ruby SOURCES. **Point this to the actual implementation, not to the spec folder**.

Sample configs, when applicable, can be found in this repository.

### Saikuro

```bash
mf-saikuro --input_directory $SOURCES --cyclo "" --filter_cyclo 0 --error_cyclo 6 --formater text --output_directory metrics/saikuro --input_directory $SOURCES
```

The output will be in file `metrics/saikuro/index_cyclo.html`.

The maximum allowed complexity is **5** for a single method, and **50** for a class. 

The command is set to show only complexities greater than or equal to 6.

### Rails Best Practices

```bash
rails_best_practices -f html --output metrics/rails-best-practices.html $SOURCES
```

The output will be in file `metrics/rails-best-practices.html`. 

**Most of the times, if you specify only a folder, many methods will be tagged as unused. Doublecheck before removing.**

### Flog

```bash
flog $SOURCES
```

The output will be on the terminal. The maximum allowed complexity is between *20/25*.

### Reek

```bash
reek -n -c $CONFIG $SOURCES
```

`CONFIG` is a YAML file (which documentation is [here](https://github.com/troessner/reek/wiki/Configuration-Files)).

The output will be on the terminal.

### Cane

```bash
cane --no-readme --no-doc --abc-glob $SOURCES/**/*.rb --style-glob $SOURCES/**/*.rb
```

The line length can be customized (`--style-measure NUM`).

The output will be on the terminal.

### Flay

```bash
flay $SOURCES
```

The output will be on the terminal.

### Roodi

```bash
mf-roodi -config=$CONFIG $SOURCES/**/*.rb
```

`CONFIG` is a YAML file.

The output will be on the terminal.

## Contributing to metrics

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (C) 2013 and above Shogun (shogun@cowtech.it).

Licensed under the MIT license, which can be found at http://www.openSOURCES.org/licenses/mit-license.php.
