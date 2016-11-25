#creates a files for each abstract

my $filename = $ARGV[0];
my $filename = "Combined_Abstracts.txt";
print("$filename");
open (IN, "<$filename");
$count = 0;


#this is a folder where we put all the seperated abstracts
my $k = 'Seperated_Abstracts/';
`mkdir Seperated_Abstracts`;


#need a for loop to select each of the protein names
my $x = "allproteins.txt";
open (FILE, "<$x");

$arraySize = $#Marray;
print ("$arraySize");
$count43 = 0;


while(<IN>) {

if ($_=~ /^PT J/){
#once in the file it hits 'PT J' it opens up a new file that records the abstract information
my $path = $k.$count."_abstract.txt";
print("$path\n");
open(NEW, ">$path") || die "couldn't open $newfile: $!";
my @analysis = ();

$count++;
print ("$count\n");
}
else{
      print NEW $_;
  }
}


#Written by Matiss Ozols