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

my @totalmatrix = ();
my @DItotal = () ;
@array_with_all_abstracts=@test;


while ($count <= $arraySize) {
	
	my $protein_name = "@all_protein_names[$count]";
	
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
		my $result_ix = index(lc($gr), lc($protein_name2));
		
		$string_after= substr $gr, $result_ix; 
		$string_before= substr $gr, 0,$result_ix; 
		@words_before=split(/ /, $string_before);
		@slice_before = @words_before[	$#words_before - 3 .. $#words_before	];	
		@words_after=split(/ /, $string_after);
		@slice_after = @words_after[0 .. 4];
		
		#print "slice after: \n";
		
		#$s=join(' ', @slice_before);
		
		#print "$string_after\n";
		
		#rint "\n$protein_name\n";
		
		
		
		$String_of_words_before_and_after=join(' ', (@slice_before, @slice_after));
		#print "$String_of_words_before_and_after\n";
		
		my @di1= grep { /DI / } @slines; 
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
		$di_with_words= "@di1[0] ( $String_of_words_before_and_after )";
		print "\n$protein_name\n";
		print "$di_with_words\n";
		
		#sleep(4);
		
		push @DI, $di_with_words; 
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
		push @DI1, ";";
		};
		
		
	foreach (@TI) {my $t1=$_;  chomp($t1);  push @TI1, $t1; push @TI1, ";";};
	
	
	push @DItotal, @DI;
	print("@DI");
	
	$NrPapers = $#DI+1;

	print("$count\n");
	$count++;
	
	if ($NrPapers>0) {

		#$protein_name =~ tr/ /_/;
		push @totalmatrix, $protein_name;
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

		push @totalmatrix, "\t";
		push @totalmatrix, @TI1;



		push @totalmatrix, "\n";
	}
	}
	
	open(NEW3, ">Proteins_Abstracts.txt") || die "couldn't open $newfile: $!";
print NEW3 @totalmatrix;


	
	
#Written by Matiss Ozols
