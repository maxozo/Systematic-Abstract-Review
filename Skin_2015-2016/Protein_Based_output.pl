#this script is supposed to separate all the abstracts in the memory and then loop through each of the protein names searching which abstracts do contain it. Issues will be experienced when we will want to loop through each data array systematicalyt, how do we specify this?
#has an abstracts, outputs the DI numbers.
#Version 1.2 Updated: removes the repeats, adds the titles.

#open the location of the all abstracts
my $dir = 'Seperated_Abstracts/';
opendir(DIR, $dir) or die $!;



while (my $file = readdir(DIR)) {

        # We only want files
        next unless (-f "$dir/$file");

        # Use a regular expression to find files ending in .txt
        next unless ($file =~ m/\.txt$/);

		push @names, $file;
		push @names, "\n";


		my $fil = $dir.$file;
		open (IN, "<$fil");
		@Marray = <IN>;
		$someNames = join(' <> ', @Marray);
		$someNames =~ s/\r|\n//g;
		
		push @test, $someNames;
		push @test, "\n";

    }



$arraySize1=$#test;
print("$arraySize1");

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

sub index2($string,$pattern){

	if (index lc($str),lc($search) > -1) {
		print "Found [$search] in [$str]\n";
	}


}

my $x = "allproteins.txt";
open (INE, "<$x");
my @all_protein_names=<INE>;
$arraySize = $#all_protein_names;
$count = 0;

my $x2 = "Ignore_These_Proteins.txt";
open (INE2, "<$x2");
my @all_protein_names_to_ignore=<INE2>;

my @totalmatrix = ();
my @DItotal = () ;
@array_with_all_abstracts=@test;


while ($count <= $arraySize) {
	
	my $protein_name = "@all_protein_names[$count]";
	$oficial_protein_name=$protein_name;
	$oficial_protein_name =~ s/\r|\n//g;
	if ( $protein_name ~~ @all_protein_names_to_ignore){
	print "passssssss!!!\n";
	}
	else{
	$protein_name =~ s/\r|\n//g;
	$protein_name =~ tr/+/./;
	$protein_name =~ tr/]/./;
	$protein_name =~ tr/[/./;
	$protein_name =~ tr/[\^\+\:\]]/./;
	$protein_name =~ s/ subunit /.*/g;	
	print("$protein_name\n");
	
	my @DI = ();
	my @TI = ();
	

	
	
	
	my @matches = grep { / $protein_name /i } @array_with_all_abstracts;


	
	foreach (@matches) {
		#loops throught each of the protein name found abstracts.
		#here we also find the 3 words before and 3 words after string
	
		
		my $gr=$_;   @slines = split(/ <> /, $gr); #splits the new lines and displays in original format to find the line containing DI and TI information.
		
		#print "\n\nAbstract: $gr\n\n";
		
		#here search for the protein name position within a sting and then extract 3 words before and after the word of interest
		$protein_name2=$protein_name;
		$protein_name2 =~ s/[*.\/]+//g;
		
		#what if there are 2 matches? what happens? get 2 context informations.
		my $offset = 0; #this will allow to get all the context matches.
		my $result_ix = index(lc($gr), lc($protein_name2),$offset);
		
		while ($result_ix != -1) {

			print "Found $protein_name2 at $result_ix\n";

			$offset = $result_ix + 1;
			

		
		
		#@result_ix2 = index(lc($gr), lc($protein_name2));
		#print @result_ix2;
		
		
		
		$string_after= substr $gr, $result_ix; 
		$string_before= substr $gr, 0,$result_ix; 
		@words_before=split(/ /, $string_before);
		@slice_before = @words_before[	$#words_before - 3 .. $#words_before	];	
		@words_after=split(/ /, $string_after);
		@slice_after = @words_after[0 .. 4];
		
		#reported issues: Doesnt like a regex: cant find a patter due to this.
		#some dont have a DOI: get a pubmed id instead PM 18606671
		@di1= grep { /DI / } @slines; 
		
		$di_with_words2= @di1[0];
		
		
		if (length($di_with_words2)<1){
		
		
		@di1 = grep{/PM /} @slines;
		$di_with_words2=@di1[0];
		
		if (length($di_with_words2)<1){
		@di1 = grep{/UT /} @slines;
		$di_with_words2=@di1[0];
				}
		
		#print "@di1[0]\n";
		
		#sleep(2);
		};
		
		
		
		$String_of_words_before_and_after=join(' ', (@slice_before, @slice_after));
		$String_of_words_before_and_after =~ s/[()]//g;
		$result_ix = index(lc($gr), lc($protein_name2),$offset);
		$di_with_words= "@di1[0] ( $String_of_words_before_and_after )";
		print $di_with_words2."\n";
		print $String_of_words_before_and_after."\n";
		
		
		push @DI, $di_with_words; 
		#sleep(2);
		}
		#remove a brackets of this string.
		
		
		
		
		my @ti1= grep { /TI / } @slines;
				
		my @ti12= grep { /epiderm*/ } @slines;


		undef $sizepi;
		undef $sizderm;


		#adding the count of the dermal and epidermal terms
		my @epi= grep { / epiderm*/ } @slines;
		$sizepi = $#epi;
		#print("@slines");
		my @derm= grep { / derm*/ } @slines;
		$sizderm = $#derm;
		#print @di1;
		
		print "\n$protein_name\n";
		#print "$di_with_words\n";
		
		#sleep(4);
		

		push @TI, @ti1; 
		
		
	};
	
	#remove the repeated entries
	
	
	my @TI = uniq(@TI);
	my @DI = uniq(@DI);
	
	#print("@TI");
	my @DI1 = ();
	my @TI1 = ();
	foreach (@DI) {
		my $d1=$_;  chomp($d1); 	
		my $n    = 3;
		my $d1 = substr($d1, $n); 
		push @DI1, $d1; 
		push @DI1, "\t";
		};
		
		
	foreach (@TI) {my $t1=$_;  chomp($t1);  push @TI1, $t1; push @TI1, ";";};
	
	
	push @DItotal, @DI;
	print("@DI");
	
	$NrPapers = $#DI+1;


	
	if ($NrPapers>0) {

		#$protein_name =~ tr/ /_/;
		push @totalmatrix, $oficial_protein_name;
		push @totalmatrix, "\t";

		push @totalmatrix, $NrPapers;
		undef $tota;
		undef $epi;
		undef $der;


		push @totalmatrix, "\t";
		push @totalmatrix, $sizepi;

		push @totalmatrix, "\t";
		push @totalmatrix, $sizder;

		push @totalmatrix, "\t";
		push @totalmatrix, @DI1;

		#we do not need a Title entries as we have context now.
		#push @totalmatrix, "\t";
		#push @totalmatrix, @TI1;



		push @totalmatrix, "\n";
	}
	}
	print("$count\n");
	$count++;
	}
	
	open(NEW3, ">Proteins_Abstracts.txt") || die "couldn't open $newfile: $!";
print NEW3 @totalmatrix;


	
	
#Written by Matiss Ozols
