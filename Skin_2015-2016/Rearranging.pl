#This script rearanges the protein based literature review and Displays the DOI first, and then proteins that are contained in this DOI

my $protein_listDOI= "Proteins_Abstracts.txt";
open (DOC, "<$protein_listDOI");
my @loop_through=<DOC>;

$arraySize = $#loop_through;



my @AllDOIs = ();
my @proteinNames= ();
my @fullStrings_forSearch=();
my @fullString=();

for (my $count=0; $count <= $arraySize; $count++) {

	my $protein_inLoop= ("@loop_through[$count]");

	#do the string processing of each : split where there is space, select protein name and put in array, take the DOIs, split them, remove the DI_ put each of them in array.

	my @seperated = split("\t", $protein_inLoop);
	my $protein_Name= ("@seperated[0]\n");
	$protein_Name =~ s/\r|\n//g;

	push @proteinNames, $protein_Name;
	push @proteinNames, "\n";




	my $DOI_string= ("@seperated[4]\n");
	#print "\n$DOI_string\n";

	
	$DOI_string =~ s/\r|\n//g;
	#$DOI_string =~ tr/;/ /;


	#seperate the DOIs and put it in one matrix
	my @seperatedDOIs = split(';', $DOI_string);




	push @fullString, $protein_Name;
	push @fullString, "; ";
	push @fullString, $DOI_string;
	$Protein = join('', @fullString);
	@fullString=();

	push @fullStrings_forSearch, $Protein;
	push @fullStrings_forSearch, "\n";

	#add the for each loop to push the data on the array with a new line entry;

	foreach (@seperatedDOIs) { 


		my $DOI=$_; 
		

		my $DOI2=(split(' \(', $DOI))[0];
		

		
		#print "\n$DOI2\n";
		#sleep(4);
		push @AllDOIs, $DOI2;
		push @AllDOIs, "\n"; 

	};

}


#print @AllDOIs;
#sleep(10);

@array = @fullStrings_forSearch;

#####################
####################
#THE FOLOWING PART OUTPUTS THE UNIQUE DOIS AND ITS ASSOCIATED PROTEINS.
####################
###################


#$seen{$_}++ foreach @AllDOIs;
my %seen;
my @uniqueDOIlist = grep { not $seen{$_} ++ } @AllDOIs;


my @DOI_based =();
my @DOI_based2 =();
#loop through each of these DOIs and list the proteins that are named in them;
splice @uniqueDOIlist, 1, 1;	
$arraySize= $#uniqueDOIlist;	

my @proteinNames = ();
@uniqueDOIlist = grep { $_ ne '' } @uniqueDOIlist;

#loop throught each of the unique DOIs

for (my $count1=0; $count1 <= $arraySize; $count1++) {
	#$arraySize;
	print("$count1\n");

	my $Doi = @uniqueDOIlist[$count1];
	
	$Doi2=$Doi;
	
	$Doi =~ tr/[\^\+\:\]]/./;   #remove regex characters

	push @DOI_based, $Doi;
	push @DOI_based, " ; ";

	#print @array;
	
	my @matches = ();	
	eval {
	
		#print "\n$Doi\n";
		@matches = grep { /$Doi/ } @array;


		
		#loop through each of the matches of the proteins found with this doi;
		my $size = ();
		$size = $#matches+1;

		push @DOI_based, " ; ";

		my @artt = ();

		for (my $counte=0; $counte <= $size; $counte++) {
			#loop throught each of the protein matches

			my $l = @matches[$counte];
			my @DOIProtein = split(';', $l);
			my $protein = @DOIProtein[0];

		#print "\n$protein\n";
		#sleep(3);
			
			push @artt, $protein;
		}

		#join the list of protein names for DOI in a string
		$someNames = join(' ; ', @artt);
		my $i=" ; ";



		#combine a result string for writing in a document
		$string12 = join('', $Doi2,$i,$size,$i,$someNames);


		push @DOI_based2, $string12;
		push @DOI_based2, "\n";

		my $p = "\n";
		@artt = ();
		
	};
	warn $@ if $@;

}



open(NEW2, ">DOI_Based_Abstracts_END.txt") || die "couldn't open $newfile: $!";
print NEW2 @DOI_based2;



#Written by Matiss Ozols

