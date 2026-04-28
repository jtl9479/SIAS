package sgis.security.mapper;


import javax.annotation.Resource;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import sgis.security.dto.user;

//  상속 UserDetailsService
// UserDetail
@Service
public class CustomUserDetailsService implements UserDetailsService {
	
	@Resource(name="securityMapper")
	SecurityMapper securityMapperr;
	
	// 디비에서 유저정보를 불러오는메소 이것을 AuthenticationProvider에서 인증을통함
	@Override
	public user loadUserByUsername(String username) throws UsernameNotFoundException {
		user userInfo = null;
		System.out.println("CustomUserDetailsService.id : "+ username);
		try {
			userInfo = securityMapperr.selectUserDetailInfo(username);
			
			if (userInfo == null) {
				throw new UsernameNotFoundException("이용자를 찾을 수 없습니다(1).");
			}
			
		} catch (UsernameNotFoundException e) { 
			 throw new UsernameNotFoundException("이용자를 찾을 수 없습니다(2).");
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//		List<UserPermission> perms = loadPermission(userInfo.getId()); 사용자권한을 불러온다.
//		List<GrantedAuthority> auth = new ArrayList<>();
//		for (UserPermission perm : perms) {
//			auth.add(new SimpleGrantedAuthority(perm.getName()));
//		}
//		return new User(username, userInfo.getPassword(), auth);
		
		//return userInfo;
		return userInfo;
	}
}
