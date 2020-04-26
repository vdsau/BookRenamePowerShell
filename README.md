  18.04.2020 - v.1.0 
        By @vdsau
        
    Transform books names ( RUS and ENG ) to format:
        Author - BookName - PublishYear  
    
    User set root folder, which from the recursive search begins.

    Additional inforamtion:
      1.) All numbers in verbal form transforms to numeric form.
            Function: Set-Numbers.
            Example transforms: 
                From:
                    Author - BookName Fifth Edition - 2010.pdf
                To:
                    Author - BookName 5 Edition - 2010.pdf
      2.) Script try to define book's publish year:
            Function:  Set-Publish.
            Example 1: 
                From:
                    Author - BookName (2010).pdf
                To:
                    Author - BookName - 2010.pdf
            Example 2: 
                From:
                    Author - BookName [2010].pdf
                To:
                    Author - BookName - 2010.pdf
            Example 3: 
                From:
                    Author - BookName 2010.pdf
                To:
                    Author - BookName - 2010.pdf
       3.) All information about editions, parts, volumes etc. 
       transfroms to short version:
            Function:  Set-Volumes.
            Example 1: 
                From:
                    Author - BookName 5 Edition - 2010.pdf
                To:
                    Author - BookName 5 Ed. - 2010.pdf
            Example 2: 
                From:
                    Author - BookName 2 Volume - 2010.pdf
                To:
                    Author - BookName 5 Vol. - 2010.pdf
        4.) Important information ( like Editions,Volumes etc.)
        will be extract from brackets or parenthesis:  
            Function:  Clear-Useless.
            Example: 
                From:
                    Author - BookName (5 Ed.) - 2010.pdf
                To:
                    Author - BookName 5 Ed. - 2010.pdf
        5.) All useless information ( like Publisher, Series etc.) 
        will be deleted:
            Function:  Clear-Useless.
            Example 1: 
                From:
                    Author - BookName (PublisherName) - 2010.pdf
                To:
                    Author - BookName - 2010.pdf
            Example 2: 
                From:
                    Author - BookName (Book Series) - 2010.pdf
                To:
                    Author - BookName - 2010.pdf
