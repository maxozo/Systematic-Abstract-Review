#this combines the files together

my $dir = 'Abstracts/';
opendir(DIR, $dir) or die $!;
print ($dir);

#lists all the txt file names

my @names = ();

my @test = () ;

 while (my $file = readdir(DIR)) {

        # We only want files
        next unless (-f "$dir/$file");

        # Use a regular expression to find files ending in .txt
        next unless ($file =~ m/\.txt$/);

		push @names, $file;
		push @names, "\n";
        print "$file\n";
		
		
		my $fil = $dir.$file;
		open (IN, "<$fil");
		print ("$fil\n");
		@Marray = <IN>;
		$someNames = join(', ', @Marray);
		#print("@Marray");
		push @test, $someNames;
		#print ("@test");
	
    }

$arraySize = $#names;
$count = 0;

my @combine = ();

while ($count <= $arraySize) {

my $FN = "@names[$count]";

my $ayi = $dir . $FN;

open (theFile, "$ayi");

my @f=<theFile>;

push @combine, @f;
push @combine, "\n";
#print("@f");  
 
	$count++;}
	
open(NEW11, ">Combined_Abstracts.txt") || die "couldn't open $newfile: $!";
print NEW11 @combine;	

#'''This will seperate the combined abstract file into individual abstracts'''



#runs the Seperation Script: seperates on big file withh all the abstracts in an individual abstracts
system('perl Seperate.pl');
#runs the analysis script: outpust protein based result: protein and the abstract DOIs
#for next version here get 3 words before and 3 words after the phrase searched.
system('perl Protein_Based_output.pl');
#rearranges the output and generates a DOI based output with protein names that it contains.
system('perl Rearranging.pl');


#Written by Matiss Ozols

