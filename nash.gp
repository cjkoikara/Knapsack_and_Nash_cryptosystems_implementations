---------------------PERMUTATION-----------------------
tick(n,P,redp,redbits,bluep,bluebits,c) =
{
	Pnew=vector(n+2);
	if( (c==0),						/* Deciding the path chosen input bit 0:Blue path 
											    input bit 1: Red path*/
		for( i=2,n+2,
			Pnew[i] = bitxor(P[bluep[i]],bluebits[i]);/*To either keep the bit as it is or to complement it based on the 									+/- sign in the blue path  */
		);
	,
		for( i=2,n+2,
			Pnew[i] = bitxor(P[redp[i]],redbits[i]);/*To either keep the bit as it is or to complement it based on the 									+/- sign in the red path  */
		);
	);
	Pnew[1]=c;
	return (Pnew);	
}
------------------------------------------------------
---------------------ENCRYPTION-----------------------
Encrypt(n,P,redp,redbits,bluep,bluebits,x) =
{
	len=length(x);
	ct=vector(len);
	for(i=1,len,
		print(P);
		ct[i]=bitxor(x[i],P[n+2]);			/*To either keep the bit as it is or to complement it based on the 									+/- sign in the path for the output bit */
		P=tick(n,P,redp,redbits,bluep,bluebits,ct[i]);	/* function to push one bit ahead through the path selected in the  									encyption machine The cipher text obtained just before is used here  									for the decision regarding the path, passing it as the input to the 									machine */
	);
	return (ct);
}
------------------------------------------------------
---------------------DECRYPTION-----------------------
Decrypt(n,P,redp,redbits,bluep,bluebits,x) =
{
	len=length(x);
	pt=vector(len);
	for(i=1,len,
		print(P);
		pt[i]=bitxor(x[i],P[n+2]);			/*To either keep the bit as it is or to complement it based ont the 									+/- sign in the path for the output bit */
		P=tick(n,P,redp,redbits,bluep,bluebits,x[i]);	/* function to push one bit ahead through the path selected in the  									decryption machine. The cipher text used just before is used here  									for the decision regarding the path, passing it as the input to the 									machine*/
	);
	return (pt);
}
------------------------------------------------------
Nash(x) =
{
	n=6;
	print(" NASH CRYPTOSYSTEM ");
	print("-------------------\n");
	print(" PERMUTER");
	P =  [ 0, 1, 1, 0, 1, 1, 0, 1 ];			/* The initial bits in the encryption machine*/		
	redp=[ 1, 6, 1, 5, 2, 7, 3, 4 ];			/* Represents the red path. Each redp[i] shows from where the bit at 									the ith node comes.*/
	redbits=[ 0, 0, 0, 1, 0, 0, 1, 1 ];			/*Each redbits[i] shows the action in the edge coming to the ith 									node*/
	bluep=[ 1, 7, 5, 3, 1, 2, 4, 6 ];			/* Represents the blue path. Each bluep[i] shows from where the bit 	 								at the ith node comes.*/
	bluebits=[ 0, 1, 0, 0, 1, 1, 0, 0 ];			/*Each bluebits[i] shows the action in the edge coming to the ith 									node*/

	print("Initial P : ",P);
	print("Red Path : ",redp);
	print("Red Bits : ",redbits);
	print("Blue Path : ",bluep);
	print("Blue Bits : ",bluebits);

	print("\n ENCRYPTION ");                   
	asciipt=Vecsmall(x);					/* coversion yo ascii */
	btmp=binary(asciipt[1]);				/* conversion to binary */
	l=length(btmp);
	s=8-l;
	tmp=vector(s);
	pt=concat(tmp,btmp);					/* adjusting the the length to 8*/
	print ("\nPlain Text : ",pt);

	print("\nState Change in Permuter ");
	ct=Encrypt(n,P,redp,redbits,bluep,bluebits,pt);		/*Encrypting the plain text in binary format*/
	print ("\nCipher Text ");
	print(ct);

	print("\n DECRYPTION "); 
	print("\nState Change in Permuter ");
	tmp=Decrypt(n,P,redp,redbits,bluep,bluebits,ct);	/*Decrypting the ciphertext ct*/
	apt=0;
	for(j=1,8,
		apt=apt+((2^(8-j))*tmp[j]);			/*conversion from binary to ascii*/
		);
	dct=Strchr(apt);					/* conversion from ascii to character*/
	print ("\nDecrypted Cipher Text : ",dct);
}
