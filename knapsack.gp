
Private_Key_Generator() = 
{
	k=8;
	prikey=vector(10);  					/* vector containing n, r and b n is a number larger than the largest 									number in the super increasing sequence b r is an number relatively 									prime to n and less than n*/
	r1=random(100); 
	r2=random(100);
	if( (r1<r2),		
		d=r1/r2;
	,
		d=r2/r1;
	);

	b=vector(k); 						/* super increasing key */
	b[1]=random(2^k);
	prikey[3]=b[1];
	s=b[1];

	for( i=2,8,
		b[i]=s+5+random(round(s^d));
		s=s+b[i];
		prikey[i+2]=b[i];
	
	);
	print("b : ",b);
	
	n=s+random(100);
	print("n : ",n);

	r=random(n-1);	
	while (gcd(r, n) != 1, r = random(n-1));		/* To ensure that r is relatively prime*/
	print("r :",r);
	
	prikey[1]=n;
	prikey[2]=r;
	return(prikey);
								/* The sole purpose is to make the key as random as possible. Any 									other suitable logic can be followed to generate the key*/
}

Public_Key_Generator(permute,prikey) = 
{
	k=8;
	a=vector(k);
	
	n=prikey[1];
	r=prikey[2];
	temp=vector(k);
	for( i=1,k,
		temp[i]=(prikey[i+2]*r)%n;			/* r*b[i] mod n*/
		a[permute[i]]=temp[i];				/*Applying the permutation*/
	);
	print("a : ",a);
	return(a);						/* The public key*/
}

Input_Data(pt,pubkey) =
{
	asciipt = Vecsmall(pt);					/* Character to ascii code conversion*/
	len = length(asciipt);
	print("Plain Text : ",pt);
	ctext=vector(len);
/*......................Converts the ascii input to binary and applies encryption.............................*/
	for( i=1,len,
		btmp=binary(asciipt[i]);
		l=length(btmp);
		s=8-l;
		tmp=vector(s);
		bin=concat(tmp,btmp);
		ctext[i]= Encrypt(pubkey,bin);
	);
/*............................................................................................................*/
	return(ctext);
}

Encrypt(a,y) =
{
	k=8;
	ct=0;
	for( i=1,k,
		ct=ct+(a[i]*y[i]);				/* The cipher text is the sum of numbers in the public key sequence 									where the plain text has a one in the same position.*/
	);	
	return(ct);
}

Output_Data(ct,prikey,permute) =
{	
	n=prikey[1];
	r=prikey[2];
	invr=(1/r)%n;
	print("Inverse of r : ",invr);
	len=length(ct);
	asciipt=vector(len);
/*...........................Decrypts the cipher text and converts to ascii form.......................*/
	for( i=1,len,
		tmp=Decrypt(ct[i],prikey,permute);
		for(j=1,8,
			asciipt[i]=asciipt[i]+((2^(8-j))*tmp[j]);
		);
	);
	pt=Strchr(asciipt);
	return(pt);
}
/*.....................................................................................................*/
Decrypt(ct,prikey,permute) = 
{
	k=8;
	temp_pt=vector(k);
	pt=vector(k);	
	n=prikey[1];
	r=prikey[2];
	invr=(1/r)%n;
	print("\nSum in terms of public key : ",ct);
	inv_ct= (invr*ct)%n;					/* Calculating sum in terms of private key*/
	print("Sum in terms of private key : ",inv_ct);
	i=k;
/*.................Calculating the components in the private key that contribute to the sum..............*/
	while( (i>=1),
		if( (inv_ct>=prikey[i+2]),
			temp_pt[i]=1;
			inv_ct=inv_ct-prikey[i+2];
		,
			temp_pt[i]=0;
		);
		
		pt[permute[i]]=temp_pt[i];
		i--;
	);
/*.........................................................................................................*/
	return(pt);
}

Knapsack(pt)=
{
	print(" KNAPSACK CRYPTOSYSTEM ");
	print("-----------------------");
	
	permute=[4,5,7,1,2,8,3,6];				/* The symmetric permutation applied to the super increasing key.*/ 

	print("\nPRIVATE KEY");
	prikey=Private_Key_Generator();				/*Generating the private key*/
	print("Permuter : ",permute);

	print("\nPUBLIC KEY");
	pubkey=Public_Key_Generator(permute,prikey);		/*Generating the public key*/

	print("\nENCRYPTION");
	ct = Input_Data(pt,pubkey);				/* Converts the ascii input to binary and performs encryption.*/
	print("Cipher text : ",ct);

	print("\nDECRYPTION");
	dpt = Output_Data(ct,prikey,permute);			/*Performs decryption and convert back to the ascii form.*/
	print("\nDecrypted Cipher text : ",dpt);

}


