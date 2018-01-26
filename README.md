# CVWO assignment - Todo manager

This is the todo manager designed for cvwo assignment.  
Auther: Sun Yiqun  
Matric card No.:A0177390X  
This website is deployed on heroku at: https://obscure-retreat-16228.herokuapp.com/  

## License

MIT license applied. See [LICENSE.md](LICENSE.md) for details.  

## Run this project on your computer  

### Important notes  
**This project is using rails 5.1.2, please check you have the lastest rails version(5.1.2 or higher).**  
**Puma server setting suitable for both windows and mac OS. However testing is all done on windows. If you find any problems when running this project on your local device, please raise a issue and I will try to look into it.**  

### Instructions
Firstly, clone this repo to your workspace and install gems (with bundle install).
```
$ git clone https://github.com/dukesun99/CVWO-todomanager
$ cd CVWO-todomanager
$ bundle install --without production
```
Then, run migrations.
```
$ rails db:migrate
```
Finally, run rails server.
```
$ rails server
```

