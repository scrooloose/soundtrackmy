Disclaimer
----------

This was written for the [london Digital Sizzle hackathon](http://www.thedigitalsizzle.com/) - in about 24 hours so
don't judge me bitches!

What does it do?
----------------

This app takes route data from any of the `mapmy(run|ride|rolley-polley).com`
sites and outputs in a form to be used with a special patch for [Pure
Data](http://puredata.info/) that converts it into bad-ass techno music.

That's right bitch! Turn your run into a rave!

Usage
-----

Fairly low tech right now:

    irb -r ./lib/soundtrack_my
    SoundtrackMy::Route.new("136692135", 300).output_for_pd

Where `136692135` is the route id on mapmyrun.com and `300` is the number of
data points we want to output - it will sample the data down to this number.

Constraints
----------

Because the [mapmylolcat.com](http://api.mapmyfitness.com/3.1/) API
SUCKS, it doesnt provide elevation data. So we get this data from google maps.
Suckily, they have a limit on the number of calls you can do in a day so don't
spam it too hard. Shouldn't be too much of a problem if you sample the data
down to a reasonable number. We get the elevations in batches of 50 per request
and you are allowed 2500 requests per day.
