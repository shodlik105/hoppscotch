import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';

export class SignInPasswordDto {
  @IsEmail()
  email: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;
}
