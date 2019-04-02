# Deploy docker environment for testing now easy as pie

## Setup

Just clone repository and run `install.sh` script.  

All user dialogs have two options, `yes` or `no` (for example: `Install docker? ("NO" by default)`), so press `Enter` if you want to leave option unchanged or type something and press `Enter` to change to the opposite.  

There is two environments type:

* Application shortcuts environment
![](../assets/example_app.gif)

* Desktop shortcuts environment
![](../assets/example_desktop.gif)

## Custom dockers and tasks

To create your module, simply make a new directory in the root folder with `run.sh` script inside.  

Desktop environment support only `run` and `kill` tasks.  
For application environment you can add `<task_name>.sh` in root of module
