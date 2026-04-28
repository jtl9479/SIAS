package sgis.security.mapper;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import sgis.security.dto.user;


@Component
public class CustomAuthenticationProvider implements AuthenticationProvider { //authenticationManager
	
	@Autowired
	private CustomUserDetailsService customeUserDetailsService;

	//접속자가 입력한 계정과 암호를 사용자 정보의 계정과 암호를 비교하여 일치 한다면 사용자 정보를 사용할 수 있게 허가 한다.
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		UsernamePasswordAuthenticationToken authToken = (UsernamePasswordAuthenticationToken) authentication; //유저정보와 이이디비번으으로만든다.(로그인한 유저아이디비번정보를담는다)

		System.out.println("CustomAuthenticationProvider.run()");
		user userInfo = customeUserDetailsService.loadUserByUsername(authToken.getName()); //UserDetailsService에서 유저정보를 불러온다.
		List<GrantedAuthority> authorities;
		try{
			if (userInfo == null) {
				throw new UsernameNotFoundException(authToken.getName());
			}

			// userDetailservice에서는 디비의 유저정보를 돌려주고 (순수 그냥 말그대로 유저정보만 돌려주는거임)
			//이클래스는 인증이된 유저정보를 돌려준다.
			//System.out.println("CustomAuthenticationProvider.입력한거.."+ userInfo.getPassword());
			//System.out.println("CustomAuthenticationProvider.기존정보.."+authToken.getCredentials());
			
			System.out.println("matchPassword Result  ::  "+ !matchPassword(userInfo.getPassword(), authToken.getCredentials()));
			
			if (!matchPassword(userInfo.getPassword(), authToken.getCredentials())) {  //내일 xml에 이파일들을 넣고 여기에서 암호화 대조 authToken이 뭔지알아내야함 
				System.out.println("authenticate.패스워드 MisMatch");
				throw new BadCredentialsException("not matching username or password");
			}

			authorities = (List<GrantedAuthority>) userInfo.getAuthorities(); // 유저마다 가진권한을 읽어와야하기떄문에 
//			return new UsernamePasswordAuthenticationToken(									//여기에서 유저아이디로디비에서 권한가지고와도괜찮을
//					new UserInfo(userInfo.getEnabled(), userInfo.getUsername(), null),
//					null,
//					authorities); 
			System.out.println("CustomAuthenticationProvider.authorities  :: " + authorities);
		}catch(UsernameNotFoundException e) { 
			throw new UsernameNotFoundException(e.getMessage()); 
		} catch(BadCredentialsException e) { 
			throw new BadCredentialsException(e.getMessage()); 
		} catch(Exception e) { 
			throw new RuntimeException(e.getMessage()); 
		}
		
		return new UsernamePasswordAuthenticationToken(userInfo,authToken.getName() ,authorities);
	}

	private boolean matchPassword(String password, Object credentials) {
		/*
		 * true -> 입력한 비밀번호와 DB에 있는 비밀번호 매치X
		 * false -> 입력한 비밀번호와 DB에 있는 비밀번호 매치
		 * */
		return password.equals(credentials);
	}
	@Override
	public boolean supports(Class<?> authentication) {
		return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
	}

}
