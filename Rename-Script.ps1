<#
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
#>

$root = "Q:\Books\";
$filePatterns = "*.bat", "*.ps1", "*.ini";

function Set-Numbers {
    Param(  
        [Parameter(ValueFromPipeline = $true)]
        [string]$Book   )
    $rusNumbersPattern = 'перв[ыйое]{2}', 'второ[ей]', 'трет[ьеий]{2}',
    'четв[её]рт[ыйое]{2}', 'пят[оеый]{2}', 'шесто[йе]',
    'седьмо[ей]', 'восьмо[йе]', 'девят[оеый]{2}';
    $engNumbersPattern = 'first', 'second', 'third',
    'fourth', 'fifth', 'sixth',
    'seventh', 'eighth', 'ninth';
    [regex[]]$allPatterns = $rusNumbersPattern + $engNumbersPattern;
    $matches = $Book | Select-String -Pattern $allPatterns -AllMatches;
    if ($matches.Matches.Length -ne 0) {
        $tempValue = $matches.Matches.Value;
        switch -Regex (  $tempValue ) {
            $rusNumbersPattern[0] { $Book = $Book.Replace($tempValue, "1"); break; }
            $engNumbersPattern[0] { $Book = $Book.Replace($tempValue, "1"); break; }
            
            $rusNumbersPattern[1] { $Book = $Book.Replace($tempValue, "2"); break; }
            $engNumbersPattern[1] { $Book = $Book.Replace($tempValue, "2"); break; }

            $rusNumbersPattern[2] { $Book = $Book.Replace($tempValue, "3"); break; }
            $engNumbersPattern[2] { $Book = $Book.Replace($tempValue, "3"); break; }
            
            $rusNumbersPattern[3] { $Book = $Book.Replace($tempValue, "4"); break; }
            $engNumbersPattern[3] { $Book = $Book.Replace($tempValue, "4"); break; }
            
            $rusNumbersPattern[4] { $Book = $Book.Replace($tempValue, "5"); break; }
            $engNumbersPattern[4] { $Book = $Book.Replace($tempValue, "5"); break; }
            
            $rusNumbersPattern[5] { $Book = $Book.Replace($tempValue, "6"); break; }
            $engNumbersPattern[5] { $Book = $Book.Replace($tempValue, "6"); break; }
            
            $rusNumbersPattern[6] { $Book = $Book.Replace($tempValue, "7"); break; }
            $engNumbersPattern[6] { $Book = $Book.Replace($tempValue, "7"); break; }
            
            $rusNumbersPattern[7] { $Book = $Book.Replace($tempValue, "8"); break; }
            $engNumbersPattern[7] { $Book = $Book.Replace($tempValue, "8"); break; }
            
            $rusNumbersPattern[8] { $Book = $Book.Replace($tempValue, "9"); break; }
            $engNumbersPattern[8] { $Book = $Book.Replace($tempValue, "9"); break; }
            default { break; }
        }
    }
    return $Book;
}

function Check-Volumes {
    Param(  
        [string]$Val,
        [regex[]]$Patterns,
        [string]$Book   )
    Switch -Regex ($Val) {
        $patterns[0] {
            $Book = $Book.Replace($_, 'Т.');
            Break;
        }
        $patterns[1] {
            $Book = $Book.Replace($_, 'V.');
            Break;
        }
        $patterns[2] {
            $Book = $Book.Replace($_, 'Ч.');
            Break;
        }
        $patterns[3] {
            $Book = $Book.Replace($_, 'P.');
            Break;
        }
        $patterns[4] {
            $Book = $Book.Replace($_, 'Вып.');
            Break;
        }
        $patterns[5] {
            $Book = $Book.Replace($_, 'Ver.');
            Break;
        }
        $patterns[6] {
            $Book = $Book.Replace($_, 'Изд.');
            Break;
        }
        $patterns[7] {
            $Book = $Book.Replace($_, 'Ed.');
            Break;
        }
    }
    return $Book;
}

function Set-Volumes {
    Param(  
        [Parameter(ValueFromPipeline = $true)]
        [string]$Book   )
    $rusVolumePattern = 'том[а]?(ов)?';
    $engVolumePattern = 'vol(ume)?';
    $rusPartPattern = 'част[иь]';
    $engPartPattern = 'part[s]?';
    $rusVersionPattern = 'Выпуск';
    $engVersionPattern = 'Version[s]?';
    $rusEditionPattern = 'издание';
    $engEditionPattern = 'edition';
    $allPatterns = $rusVolumePattern, $engVolumePattern, $rusPartPattern, $engPartPattern, $rusVersionPattern, $engVersionPattern, $rusEditionPattern, $engEditionPattern;
    $matches = $Book | Select-String -Pattern $allPatterns -AllMatches;
    if ($matches.Matches.Length -ne 0) {
        $temp = $matches.Matches.Value;
        if ($temp -is [System.Array]) { 
            for ($i = 0; $i -lt $temp.Length; $i++) {
                $Book = Check-Volumes -Val $temp[$i] -Patterns $allPatterns -Book $Book;  
            }
        }
        else {
            $Book = Check-Volumes -Val $temp -Patterns $allPatterns -Book $Book;  
        }
    }
    return $Book;
}

function Set-Publish {
    Param(  
        [Parameter(ValueFromPipeline = $true)]
        [string]$Book   )
    $yearsPatterns = '(?<parenthesisYear> *\(\d{4}\)*\.*)';
    $yearsBrackets = '(?<bracketsYear> *\[\d{4}\]\.*)';
    $yearsSimple = '(?<simpleYear> ([^.]\s)*\d{4}$)';
    $allPatterns = $yearsPatterns, $yearsBrackets, $yearsSimple;
    $clearYear = '\d{4}';
    $matches = $Book | Select-String -Pattern $allPatterns;
    $publishDate = $matches.Matches.Value | Select-String -Pattern $clearYear;
    if ($publishDate.Matches.Length -ne 0) {
        $position = $matches.Matches.Index;
        $publishDate = $publishDate.Matches.Value;
        $Book = $Book.Remove($position, $Book.Length - $position ) + " - $publishDate";
    }
    return $Book;
}

function Get-BookNumberByTemplate {
    Param( [string]$Template )
    $number = 0;
    $matches = $Template | Select-String -Pattern '\d{1,2}';
    if ($matches.Matches.Length -ne 0) {
        $number = $matches.Matches.Value;  
    }
    return $number;
}

function Check-Neccessaries {
    Param(  
        [string]$Val,
        [string[]]$Patterns,
        [string]$Book   )
    $edition = Get-BookNumberByTemplate -Template $Val;
    if ($edition -ne 0) {
        Switch -Regex ($Val) {
            $Patterns[0] {
                $Book = $Book.Replace($_, "Изд.$edition ");
                Break;
            }
            $Patterns[4] {
                $Book = $Book.Replace($_, "Ed.$edition ");
                Break;
            }
            $Patterns[1] {
                $Book = $Book.Replace($_, "Т.$edition ");
                Break;
            } 
            $Patterns[5] {
                $Book = $Book.Replace($_, "V.$edition ");
                Break;
            }
            $Patterns[2] {
                $Book = $Book.Replace($_, "Ч.$edition ");
                Break;
            } 
            $Patterns[6] {
                $Book = $Book.Replace($_, "P.$edition ");
                Break;
            } 
            $Patterns[3] {
                $Book = $Book.Replace($_, "Вып.$edition ");
                Break;
            } 
            $Patterns[7] {
                $Book = $Book.Replace($_, "Ver.$edition ");
                Break;
            } 
        }
    }
    return $Book;
}
function Get-Neccessary {
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$Book)
    $rusNeededPattern = "\(.*Изд\..*\)", "\(.*Т\..*\)", "\(.*Ч\..*\)", "\(.*Вып\..*\)";
    $engNeededPattern = "\(.*Ed\..*\)", "\(.*V\..*\)", "\(.*P\..*\)", "\(.*Ver\..*\)";
    $allPatterns = $rusNeededPattern + $engNeededPattern; 
    $matches = $Book | Select-String -Pattern $allPatterns -AllMatches -CaseSensitive;
    if ($matches.Matches.Length -ne 0) {
        $temp = $matches.Matches.Value;
        if ($temp -is [System.Array]) { 
            for ($i = 0; $i -lt $temp.Length; $i++) {
                $Book = Check-Neccessaries -Patterns $allPatterns -Val $temp[$i] -Book $Book;
            }
        }
        else {
            $Book = Check-Neccessaries -Patterns $allPatterns -Val $temp -Book $Book;
        }
    }
    return $Book;
}

function Clear-Useless {
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$Book)
    $parenthesisWithInfo = "\(.*\)";
    $bracketsWithInfo = "\[.*\]";
    $oreillyUseless = "O\'Reilly Media$";
    $allPatterns = $parenthesisWithInfo , $bracketsWithInfo, $oreillyUseless;
    $Book = Get-Neccessary -Book $Book;
    $matches = $Book | Select-String -Pattern $allPatterns -AllMatches;
    if ($matches.Matches.Length -ne 0) {
        $temp = $matches.Matches.Value;
        if ($temp -is [System.Array]) { 
            for ($i = 0; $i -lt $temp.Length; $i++) {
                Switch -Regex ($temp[$i]) {
                    $parenthesisWithInfo {
                        $Book = $Book.Replace($temp[$i], '');
                        Break;
                    }
                }
            }
        }
        else {
            Switch -Regex ($temp) {
                $parenthesisWithInfo {
                    $Book = $Book.Replace($temp, '');
                    Break;
                }
                $bracketsWithInfo {
                    $Book = $Book.Replace($temp, '');
                    Break;
                }
                $oreillyUseless {
                    $Book = $Book.Replace($temp, '');
                    Break;
                }
            }
        }
    }
    return $Book;
}

Get-ChildItem -LiteralPath $root -Name -Recurse -Force -Exclude $filePatterns | ForEach-Object {
    $book = Get-Item -LiteralPath $root$_;
    if ($book -is [System.IO.FileInfo]) {
        $clearedBookName = Set-Numbers -Book $book.BaseName | Set-Publish | Set-Volumes | Clear-Useless;
        $newBookName = $book.DirectoryName + "\" + $clearedBookName + $book.Extension;
        Rename-Item -LiteralPath "$root$_" -NewName  $newBookName -Force;
        Write-Output -InputObject  $newBookName;
    }
} 