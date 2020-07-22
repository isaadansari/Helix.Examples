                                  ww,                         
                    r"**&,   L /`g                            
            $M     ,wggw, `k ]$  N&                           
            $r   ,$$,gg,,'~  ,$$  @w,                         
            \$gg$$$@"-s* ,g@$$P      *,                       
              *$$@" gF g@$$$$F | |'   x'=                     
          g,,y$@" gl ,@$$$$$@ |     |L  %g                    
          *M* ,gll ,$$$$$$$F |    |`,gQ $$@g                  
    g$$$$@gg$$lllL @$$$$$$$r  ,''  *&&ll  *M                  
       `""***"`Al ]$$$$$$$$L ]ll&        '`                   
         $  %g&*l ]$$$$$$$$$  Yll$            /|!L:,,,,       
          $$g,,w$l  $$$$$$$$$@  $ll$          '  '``''''''    
          $lllll$  ]$$$$$$@R**  *lll,      @@,       '" :| L  
            "^"     %$$P`,g@@@r   "*4&,  ,@$$$F            '!   
                      `g@$$$$" ,g@$$Qgww,,,,,,,,,,          
                      $$$$$$F $llllllllllllllllllllL          
                    /$$$$$$@ '$llllllllllllllM" Yl$           
                    /$$$$$$$$@g  `"****""`l&   @F,F           
                  ,N*"  ]$$$$$$$$@@@@@@` "    g",`            
                    $$lL ]$$$$$$$$$$P` r     / ;`             
                      *lg ]$$$$$P"  ,r  ggg, ,$l              
                        "  N"  ,<&"  g$$$$$k `                
                              '"`         `      
        Konabos Consulting Inc - www.konabos.com

# Sample Docker Helix Examples Solution

This is a sample Sitecore solution that has been "Dockerified". The changes are minimal, take a look at the commit history in this fork to see the changes. At a high level:
 
 - Removed all the default local setup scripts (for clean up purposes)
 - Added the Docker folder, compose files, sample scripts and data folder used for mounts
 - Updated the Publish Profile to deploy into the Docker/data folder
 - Added configs to enable Identity Server and LiveMode

## Steps to get started

First build the images:
 - Ensure [Hyper-V is enabled]( https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v), both in Windows and your BIOS.
 - Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
 - Clone the Sitecore Community [Docker Images repo](https://github.com/Sitecore/docker-images)
 - Follow the quick start and build the images 

Then in this repo:
 - Open a Powershell window with elevated admnin privileges (or better, [install Windows Terminal](https://github.com/microsoft/terminal))
 - Install [`whales-names`](https://www.npmjs.com/package/whales-names) - this only needs to be once on your machine
 > `npm install -g whales-names`
 - Install the sample wildcard SSL cert to your local certmgr
 > `.\Docker\startup\importcert.ps1`
 - From the `.\Docker` folder, run `.\start.ps1`

Now wait for your Docker instance to start up. When all the containers are up and running, browse to https://cm.helixexamples.local/sitecore/ and ensure you can log into the clean instance.

In another PS window (or Terminal tab)
 - From the root folder `.\deploy.ps1`
 - Wait for the solution to be built, published and the Unicorn sync to finish
 - Browse to https://cm.helixexamples.local in an incognito window or different browser and ensure the Helix Examples homepage loads

## Custom Environment Variables

A number of defauilt variables have been set in `.\Docker\.env` file. This is a standard Docker format variable file. Notably, the default in this runs
 - Sitecore 9.3 
 - in Process isolation mode
 - for Windows update 1909
 - using the `docker-compose.xp.sxa.yml` compose file

Update the values to match your local machine and requirements. If you built and pushed your images up to a private conatainer registry, don't forget to set the REGISTRY value (ending with a `/`).

In team scenarios it is not uncommon for different team members to be running different updates of Windows, or some team members to have different amounts of resources available. We have a custom solution is place to allow user specific override files. To use custom variables:
 
- Go to `.\Docker` folder
- Copy `.env.user.example` and name it `.env.user`
- Edit the file with your specific requirements. Adjust the memory limits as required, or delete them to use the defaults set in the compose files.
- This file is set to be ignored for git check-in, so you do to have to worry about it overriding a team members setting


## Sample Scripts

A few sample PowerShell scripts have been provided to help with the docker instance.

**.\Docker\Clean-Data.ps1**

This cleans the files from your local Docker instance, allowing you to start fresh. Ensure you have stopped the Docker instance first. 

By default, this command will NOT delete the databases. To also remove the database and start completely clean, pass in the `-IncludeDatabases` flag when calling the script.
 
**.\Docker\Restart-Docker.ps1**

This script will compose down the Docker instance, remove any dangling containers, restart the system Docker daemon and the run start.ps1
 
**.\Docker\Start.ps1**

The script will remove any dangling containers, start the Docker instance (with a user specific environment file if it present) and then run whales-names to allow custom local domain mapping.
 
**.\Docker\Stop.ps1**

This script will compose down your instance and remove any dangling containers.

**.\Deploy.ps1**

This script will restore the nuget packages, build the solution with msbuild and then trigger the publish using the Local profile. It will then trigger a Unicorn Sync call.

Note: This sample only builds/deploys the helix-basic-unicorn exmaple.

## SSL Certs

An exmaple wildcard SSL cert has been created and check-in to the `.\Docker\startup` folder. You can read more in this [blog post by Michael West](https://michaellwest.blogspot.com/2020/01/secure-docker-websites-for-sitecore.html) about how to generate your own if you wish.

