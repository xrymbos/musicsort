use  File::Find;
use File::Path;
use File::Copy;
use Ogg::Vorbis::Header::PurePerl;
use Cwd;

$runDir = getcwd;
$musicDir = "$runDir/My Music";
$startDir = "./";
@directories = ("./");

find(\&wanted, @directories);

sub wanted {

    $fileName = $_;
    $ext = substr($fileName,-4);

    if($ext eq ".ogg"){
	$ogg = Ogg::Vorbis::Header::PurePerl->new($fileName);

	$title = ($ogg->comment("title"))[0];
	$artist = ($ogg->comment("artist"))[0];
	$album = ($ogg->comment("album"))[0];

	if($title eq "" || $artist eq "" || $album eq ""){
	    print "$fileName has missing data!\n";
	}
	else{
	    $directory="$musicDir/$artist/$album";
	    $filePath="$directory/$title.ogg";

	    if(!(-d $directory)){
		mkpath($directory);
	    }

	    print "Moving $fileName to $filePath\n";
	    move("$fileName",$filePath);
	}
    }
}
