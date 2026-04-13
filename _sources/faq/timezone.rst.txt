Timezone
========

How Are Timezones Handled?
--------------------------

The system timezone is used when computing time values, which are sometimes
used for one of the two coordinates. In most cases this gives consistent time
values from one run to the next. Inconsistency may appear if:

1. The system timezone is changed on the computer running Engauge.
2. A document is opened on another computer with a different timezone.

How to Fix the Timezone
-----------------------

If time values are incorrect due to a timezone issue, there are two solutions:

**TZ environment variable**
    Set ``TZ`` to a value like ``America/Los_Angeles`` before launching Engauge.
    This fix only affects the shell where ``TZ`` is set.

**System timezone**
    Change the system timezone using your operating system's interface. This
    affects all applications.

Instructions for implementing either solution can be found online for your
operating system.
