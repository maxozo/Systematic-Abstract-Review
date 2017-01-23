#This script rearanges the protein based literature review and Displays the DOI first, and then proteins that are contained in this DOI
#use 5.010;
$protein_listDOI= "Proteins_Abstracts.txt";
open (DOC, "<$protein_listDOI");
@loop_through=<DOC>;

$arraySize = $#loop_through;



@AllDOIs = ();
@proteinNames= ();
@fullStrings_forSearch=();
@fullString=();

for ($count=0; $count <= $arraySize; $count++) {

	$protein_inLoop= ("@loop_through[$count]");

	#do the string processing of each : split where there is space, select protein name and put in array, take the DOIs, split them, remove the DI_ put each of them in array.

	@seperated = split("\t", $protein_inLoop);
	$protein_Name= ("@seperated[0]\n");
	$protein_Name =~ s/\r|\n//g;

	push @proteinNames, $protein_Name;
	push @proteinNames, "\n";

	
	
	#print "@seperated\n";
	

	@DOI_string2= @seperated[3 .. $#seperated];
	foreach(@DOI_string2){
	
	$DOI_string = $_;
	

	#here select all the entries till the end.
	
	
	#print "\n$DOI_string\n";

	
	$DOI_string =~ s/\r|\n//g;
	#$DOI_string =~ tr/;/ /;


	#seperate the DOIs and put it in one matrix
	




	push @fullString, $protein_Name;
	push @fullString, "; ";
	push @fullString, $DOI_string;
	$Protein = join('', @fullString);
	@fullString=();

	push @fullStrings_forSearch, $Protein;
	push @fullStrings_forSearch, "\n";

	#add the for each loop to push the data on the array with a new line entry;

	


	$DOI=$DOI_string; 
		

	$DOI2=(split(' \(', $DOI))[0];
		
	#print $DOI2."\n";
	#sleep(2);

		
		#print "\n$DOI2\n";
		#sleep(4);
		if (length($DOI2)<2){
		#print "Not Adding";
		}
		else{
		push @AllDOIs, $DOI2;
		push @AllDOIs, "\n"; 
		}
	}
	
	
}


@array = @fullStrings_forSearch;

#####################
####################
#THE FOLOWING PART OUTPUTS THE UNIQUE DOIS AND ITS ASSOCIATED PROTEINS.
####################
###################

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

#$seen{$_}++ foreach @AllDOIs;
@uniqueDOIlist=uniq(@AllDOIs);
print "length!!!!!\n $#AllDOIs \n";
print $#AllDOIs;

my %seen;
#@uniqueDOIlist = @AllDOIs;
print @uniqueDOIlist;
#sleep(30);

my @DOI_based =();
my @DOI_based2 =();
#loop through each of these DOIs and list the proteins that are named in them;
splice @uniqueDOIlist, 1, 1;	
$arraySize= $#uniqueDOIlist;	

my @proteinNames = ();
@uniqueDOIlist = grep { $_ ne '' } @uniqueDOIlist;
#exit 42;
#sleep(30);

#loop throught each of the unique DOIs
#add : IgnoreTheseDOIs
my $x2 = "Ignore_These_DOIs.txt";
open (INE2, "<$x2");
@all_DOI_names_to_ignore=<INE2>;

for (my $count1=0; $count1 <= $arraySize; $count1++) {
	#$arraySize;
	print("$count1\n");

	my $Doi = @uniqueDOIlist[$count1];
	
	if ( $Doi ~~ @all_DOI_names_to_ignore){
	print "passssssss!!!\n";
	}
	else{
	
	
	
	$Doi2=$Doi;
	print $Doi2."\n";
	#sleep(1);
	$Doi =~ tr/[\^\+\-\(\)\:\]]/./;   #remove regex characters

	push @DOI_based, $Doi;
	push @DOI_based, "\t";

	#print @array;
	
	@matches = ();	
	eval {
	
		print "\n$Doi\n";
		#sleep(2);
		@matches = grep { /$Doi/ } @array;


		
		#loop through each of the matches of the proteins found with this doi;
		$size = ();
		$size = $#matches+1;

		push @DOI_based, "\t";

		@artt = ();

		for ($counte=0; $counte <= $size; $counte++) {
			#loop throught each of the protein matches

			my $l = @matches[$counte];
			@DOIProtein = split("\t", $l);
			$protein = @DOIProtein[0];
			@protein_act=split("; ", $protein);
		#print "proteeeeiiinnnssss!!\n";
		#print "\n@protein_act\n";
		#sleep(3);
			
			push @artt, $protein;
		}

		#join the list of protein names for DOI in a string
		$someNames = join("\t", @artt);
	
		$i="\t";

		#in somenames replace the doi string
		$someNames =~ s/; $Doi//g;
		#print "somenamess === ".$someNames."\n";
		#sleep(3);
		
		
		#combine a result string for writing in a document
		$string12 = join('', $Doi2,$i,$size,$i,$someNames);


		push @DOI_based2, $string12;
		push @DOI_based2, "\n";

		$p = "\n";
		@artt = ();
		
	};
	warn $@ if $@;
	}
}



open(NEW2, ">DOI_Based_Abstracts_END.txt") || die "couldn't open $newfile: $!";
print NEW2 @DOI_based2;



#Written by Matiss Ozols

