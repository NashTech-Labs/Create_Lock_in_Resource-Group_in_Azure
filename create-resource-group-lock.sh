#!/bin/bash

echo "List of All ResourceGroup:"
az group list --query [].[name] -o table | awk '/^Column1|^-----|^Column1/ {next}{for (i=1;i<=NF;i++){print $i}}'

echo "Enter ResourceGroup Name on which you want to have a lock:"
read rgname


echo "====Checking lock exist on ResourceGroup or not====="

az lock list -otable --resource-group $rgname > rg-lock.txt

        if grep -w -i $rgname rg-lock.txt
        then

          echo "Already having a Lock on the resource group"

      rm rg-lock.txt

        else
        echo "----Creating a Lock on the ResourceGroup ----"

        echo "Enter the Name of lock:"
        read lockname

        read -p "Enter number for:
            1.ReadOnly
            2.CanNotDelete ---> " choice

            N1="ReadOnly"
            N2="CanNotDelete"

         case $choice in
             1)

              az lock create --name $lockname --lock-type $N1 --resource-group $rgname

             ;;
             2)
               az lock create --name $lockname --lock-type $N2 --resource-group $rgname

             ;;
             *)
             echo "Unknown value"
             ;;
            esac

          rm rg-lock.txt

        fi
