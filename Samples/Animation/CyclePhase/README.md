# Animation using repeating Cycle

This animation uses a `Cycle` to create a continous animation of dots appearing from the left and moving to the right.

`Waveform="Sawtooth"` on the `Cycle` is the basic way to get a repeating cycle. This waveform plays from progress=0 through to 1 and then wraps to 0 again (unlike the default sine waveform than goes back and forth smoothly).

The `Dot.TimeOffset` is set as the `Cycle.ProgressOffset` to stagger each of the dots. Note that this is only appropriate for triggers that are always on while visible to the user (such as `WhileVisible`). By overriding the default `ProgressOffset` we prevent `Cycle` from reverting smoothly to a rest state, which happens when triggers are deactivated. This would create a visible jerk/jump in the animation.
